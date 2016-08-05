class Review < ApplicationRecord
  belongs_to :restaurant  #to generate methods  review.restaurant
  belongs_to :user  #to generate methods  review.restaurant
  has_many :endorsements
  validates :rating, inclusion: (1..5)
  validates :user, uniqueness: { scope: :restaurant, message: "has reviewed this restaurant already" }

  def star_rating
    '★' * rating  + '☆' * (5 - rating)
  end

end
