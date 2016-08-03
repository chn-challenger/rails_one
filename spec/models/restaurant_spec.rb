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
    user_2 = User.create(email: 'joe1234@joe.com',
      password: '123454321', password_confirmation: '123454321')
    kfc_2 = user.restaurants.new(name: 'KFC')
    expect(kfc_2).to have(1).error_on(:name)
  end

  describe '#average_rating' do
    context 'no reviews' do
      it 'returns "N/A" when there are no reviews' do
        restaurant = Restaurant.create(name: 'The Ivy')
        expect(restaurant.average_rating).to eq 'N/A'
      end
    end

    context 'average review ratings' do
      it 'returns average of two ratings' do
        user = User.create(email: 'joe123@joe.com',
          password: '12344321', password_confirmation: '12344321')
        kfc = user.restaurants.create(name: 'KFC')
        user_1 = User.create(email: 'joe12345@joe.com',
          password: '123454321', password_confirmation: '123454321')
        user_2 = User.create(email: 'joe1234@joe.com',
          password: '123454321', password_confirmation: '123454321')
        kfc.reviews.build_with_user({thoughts: 'bad bad', rating: 5},user_1)
        kfc.reviews.build_with_user({thoughts: 'good good', rating: 3},user_2)
        expect(kfc.average_rating).to eq "★★★★☆"
      end
    end
  end

end
