class Restaurant < ApplicationRecord
  belongs_to :user
  has_many :reviews, dependent: :destroy    #to allow restaurant.reviews.new / create
  validates :name, length: {minimum: 3}, uniqueness: true

  # def user
  #   user_id = read_attribute(:user_id)
  #   User.find(user_id)
  # end

end
