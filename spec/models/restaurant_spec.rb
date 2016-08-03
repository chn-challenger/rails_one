require 'spec_helper'

describe Restaurant, type: :model do
  it 'is not valid with a name of less than three characters' do
    restaurant = Restaurant.new(name: "kf")
    expect(restaurant).to have(1).error_on(:name)
    expect(restaurant).not_to be_valid
  end

  it "is not valid unless it has a unique name" do
    user = User.create(email: 'joe123@joe.com',
      password: '12344321', password_confirmation: '12344321')
    kfc = user.restaurants.create(name: 'KFC')
    # Restaurant.create(name: "Moe's Tavern")
    user_2 = User.create(email: 'joe1234@joe.com',
      password: '123454321', password_confirmation: '123454321')
    kfc_2 = user.restaurants.new(name: 'KFC')
    # restaurant = Restaurant.new(name: "Moe's Tavern")
    expect(kfc_2).to have(1).error_on(:name)
  end

  # xit 'can only be deleted by owner' do
  #   user = User.create(email: 'joe123@joe.com',
  #     password: '12344321', password_confirmation: '12344321')
  #   kfc = user.restaurants.create(name: 'KFC')
  #
  # end
end
