class RestaurantsController < ApplicationController

  before_action :authenticate_user!, :except => [:index, :show]

  def index
    @restaurants = Restaurant.all
  end

  def new
    @restaurant = current_user.restaurants.new
  end

  def create
    @restaurant = current_user.restaurants.new(restaurant_params)
    if @restaurant.save
      redirect_to restaurants_path
    else
      render 'new'
    end
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end

  def edit
    @restaurant = Restaurant.find(params[:id])
    if current_user != @restaurant.user
      flash[:notice] = 'You can only edit your own restaurant'
      redirect_to '/restaurants'
    end
  end

  def update
    @restaurant = Restaurant.find(params[:id])
    if current_user == @restaurant.user
      @restaurant.update(restaurant_params)
    else
      flash[:notice] = 'You can only edit your own restaurant'
    end
    redirect_to '/restaurants'
  end

  def destroy
    @restaurant = Restaurant.find(params[:id])
    if current_user == @restaurant.user
      @restaurant.destroy
      flash[:notice] = 'Restaurant deleted successfully'
    else
      flash[:notice] = 'You only delete your own restaurants'
    end
    redirect_to '/restaurants'
  end

  def restaurant_params
    params.require(:restaurant).permit!
  end

end
