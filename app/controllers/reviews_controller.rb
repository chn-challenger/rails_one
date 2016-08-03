class ReviewsController < ApplicationController

  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    if @restaurant.user == current_user
      flash[:notice] = 'You cannot review your own restaurants'
      redirect_to restaurants_path
    else
      @review = Review.new
    end
  end

  def create
    # @restaurant = Restaurant.find params[:restaurant_id]
    # @review = @restaurant.reviews.new(review_params)
    # @review.user = current_user

    # @review = current_user.reviews.new(review_params)
    # @review.restaurant = Restaurant.find params[:restaurant_id]

    @restaurant = Restaurant.find params[:restaurant_id]
    @review = @restaurant.reviews.build_with_user review_params, current_user

    if @review.save
      redirect_to restaurants_path
    else
      if @review.errors[:user]
        flash[:notice] = 'You have already reviewed this restaurant'
        redirect_to restaurants_path
      else
        render :new
      end
    end
  end

  private

  def review_params
    params.require(:review).permit(:thoughts, :rating)
  end

end
