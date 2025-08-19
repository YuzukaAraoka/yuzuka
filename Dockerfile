# syntax=docker/dockerfile:1
ARG RUBY_VERSION=3.2.8             # .ruby-version / Gemfile と揃える
FROM ruby:${RUBY_VERSION}-slim AS base
ENV RAILS_ENV=production \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_WITHOUT="development:test" \
    BUNDLE_PATH=/usr/local/bundle
WORKDIR /rails
# ---------- builder ----------
FROM base AS build
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
      build-essential git pkg-config libpq-dev libyaml-dev libvips && \
    rm -rf /var/lib/apt/lists/*
# Gem は先にコピー（キャッシュ効かせる）
COPY Gemfile Gemfile.lock ./
# Windows 由来のロックでも Linux で解決できるように
RUN bundle lock --add-platform x86_64-linux || true
# ARM/Linux の場合は必要に応じて:
# RUN bundle lock --add-platform aarch64-linux || true
RUN bundle install --jobs 4 --retry 3 && \
    rm -rf ~/.bundle/ ${BUNDLE_PATH}/ruby/*/cache ${BUNDLE_PATH}/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile
# アプリ本体
COPY . .
# CRLF→LF / 実行権限（Windows由来対策）
RUN chmod +x bin/* && \
    sed -i 's/\r$//g' bin/* && \
    sed -i 's/ruby\.exe$/ruby/' bin/*
# bootsnap（アプリコード用） & アセット
RUN bundle exec bootsnap precompile app/ lib/ && \
    SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile
# ---------- runtime ----------
FROM base AS app
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
      curl libsqlite3-0 libvips libjemalloc2 sqlite3 libpq5 && \
    rm -rf /var/lib/apt/lists/*
# 生成物をコピー
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails
# 非rootで実行
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails /rails
USER rails:rails
# エントリポイント & サーバ
EXPOSE 3000
ENTRYPOINT ["/rails/bin/docker-entrypoint"]
CMD ["./bin/rails","server","-b","0.0.0.0","-p","3000"]