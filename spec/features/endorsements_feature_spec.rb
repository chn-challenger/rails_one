require 'rails_helper'

feature 'endorsing reviews' do
  scenario 'a user can endorse a review, which updates the review endorsement count', js: true do
    user = User.create(email: 'joe123@joe.com',
      password: '12344321', password_confirmation: '12344321')
    kfc = user.restaurants.create(name: 'KFC')
    review = kfc.reviews.build_with_user({rating: 3, thoughts: 'It was an abomination'},user)
    review.save
    visit '/restaurants'
    click_link 'Endorse Review'
    expect(page).to have_content('1 endorsement')
  end

  xscenario 'Can endorse twice' do
    user = User.create(email: 'joe123@joe.com',
      password: '12344321', password_confirmation: '12344321')
    kfc = user.restaurants.create(name: 'KFC')
    review = kfc.reviews.build_with_user({rating: 3, thoughts: 'It was an abomination'},user)
    review.save
    visit '/restaurants'
    click_link 'Endorse Review'
    click_link 'Endorse Review'
    expect(page).to have_content('2 endorsement')
  end
end
# <p><%= pluralize review.endorsements.count, 'endorsement' %></p>
# <%= form_for @restaurant do |f| %>
#   <%= f.label :name %>
#   <%= f.text_field :name %>
#   <%= f.label :description %>
#   <%= f.text_area :description %>
#   <%= f.submit %>
# <% end %>
