class Restaurant < ApplicationRecord
  belongs_to :user
  validates :name, length: {minimum: 3}, uniqueness: true

  has_many :reviews, dependent: :destroy do
    def build_with_user(attributes = {}, user)
      attributes[:user] ||= user
      build(attributes)
    end
  end



  def average_rating
    return "N/A" if reviews.length == 0
    ave_rating = (reviews.inject(0){|r,x| r + x.rating} / reviews.length.to_f).round(0).to_i
    '★' * ave_rating  + '☆' * (5 - ave_rating)
  end

end
