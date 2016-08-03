class Restaurant < ApplicationRecord
  has_many :reviews, dependent: :destroy    #to allow restaurant.reviews.new / create
  validates :name, length: {minimum: 3}, uniqueness: true 
end
