class PerfumesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  def index
    @perfumes = Perfume.order(created_at: :desc)
  end
  def new
    @perfume = Perfume.new
  end
  def show
    @perfume = Perfume.find_by(id: params[:id])
    return redirect_to perfumes_path, alert: "見つかりませんでした" if @perfume.nil?
  end
  def create
    @perfume = current_user.perfumes.new(perfume_params) # user_id を自動セット
  if @perfume.save
    flash[:notice] = "診断が完了しました"
    redirect_to perfume_path(@perfume)
  else
    flash[:alert] = @perfume.errors.full_messages.join(", ")
    render :new
  end

  end
  private
  def perfume_params
    params.require(:perfume).permit(:name, :brand, :notes, :question1, :question2, :question3, :question4)
  end
end











