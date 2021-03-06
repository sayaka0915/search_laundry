class LaundriesController < ApplicationController
  before_action :search_laundry, only: [:index, :search]
  before_action :set_laundry, only: [:show, :edit, :update]
  before_action :check_user, except: [:index, :show, :search]

  def index
    @laundries = Laundry.order('opening_date DESC').with_attached_image.page(params[:page])
    @laundries_count = Laundry.count
  end

  def new
    @laundry = Laundry.new
  end

  def create
    @laundry = Laundry.new(laundry_params)
    if @laundry.save
      redirect_to root_path
    else
      render :new
    end
  end

  def search
    @results = @laundry.result.order('opening_date DESC').with_attached_image.page(params[:page])
    @results_count = @laundry.result.count
  end

  def show
    @comments = @laundry.comments.includes(:user)
    @comment = Comment.new
    @places = @laundry.nearbys(5, units: :km)
    # 以下GoogleMap表示用
    gon.latitude = @laundry.latitude
    gon.longitude = @laundry.longitude
    gon.places = @places
  end

  def destroy
    laundry = Laundry.find(params[:id])
    if laundry.destroy
      redirect_to root_path, notice: '削除が完了しました'
    else
      redirect_to root_path, alert: '削除が失敗しました'
    end
  end

  def edit
  end

  def update
    if @laundry.update(laundry_params)
      redirect_to action: :show
    else
      render :edit
    end
  end

  private

  def check_user
    redirect_to root_path unless user_signed_in? && current_user.admin?
  end

  def set_laundry
    @laundry = Laundry.find(params[:id])
  end

  def search_laundry
    @laundry = Laundry.ransack(params[:q])
  end

  def laundry_params
    params.require(:laundry).permit(:name, :address, :opening_date, :open_time, :close_time, :shoe_washing, :futon_washing, :dryer, :washing_machine, :image)
  end
end
