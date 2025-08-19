class TweetsController < ApplicationController
    before_action :authenticate_user!, only: [:new, :create]
    def index
     @tweets = Tweet.all   
    end

    def new
       @tweet = Tweet.new
       @tweets = Tweet.all
    if params[:search] == nil 
        @tweets= Tweet.all
      elsif params[:search] == ''
        @tweets= Tweet.all
      else
        #部分検索
        @tweets = Tweet.where("title LIKE ? ",'%' + params[:search] + '%')
      end

    end

    def create
        tweet = Tweet.new(tweet_params)
        tweet.user_id = current_user.id

        if tweet.save!
        redirect_to :action => "new"
        else
        redirect_to :action => "new"
        end
    end

    def top

    end
   
    
  private
  def tweet_params
    params.require(:tweet).permit(:title, :information, :image)
  end



end
