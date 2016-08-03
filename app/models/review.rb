class Review < ApplicationRecord
  belongs_to :restaurant  #to generate methods  review.restaurant
  validates :rating, inclusion: (1..5) 
end
