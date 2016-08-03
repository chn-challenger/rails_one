require 'rails_helper'

feature 'reviewing' do
  let!(:user){User.create(email: 'joe123@joe.com',
      password: '12344321', password_confirmation: '12344321')}
  let!(:kfc){user.restaurants.create(name:'KFC') }

  scenario 'allows users to leave a review using a form' do
     visit '/restaurants'
     click_link('Sign up')
     fill_in('Email', with: 'test@example.com')
     fill_in('Password', with: 'testtest')
     fill_in('Password confirmation', with: 'testtest')
     click_button('Sign up')
     click_link 'Review KFC'
     fill_in "Thoughts", with: "so so"
     select '3', from: 'Rating'
     click_button 'Leave Review'
     expect(current_path).to eq '/restaurants'
     expect(page).to have_content('so so')
  end

  scenario 'cannot review same restaurant twice' do
     visit '/restaurants'
     click_link('Sign up')
     fill_in('Email', with: 'test@example.com')
     fill_in('Password', with: 'testtest')
     fill_in('Password confirmation', with: 'testtest')
     click_button('Sign up')
     click_link 'Review KFC'
     fill_in "Thoughts", with: "so so"
     select '3', from: 'Rating'
     click_button 'Leave Review'
     click_link 'Review KFC'
     fill_in "Thoughts", with: "bad bad"
     select '4', from: 'Rating'
     click_button 'Leave Review'
     expect(current_path).to eq '/restaurants'
     expect(page).to have_content('You have already reviewed this restaurant')
  end

  scenario 'cannot review own restaurant' do
     visit '/restaurants'
     click_link('Sign in')
     fill_in('Email', with: 'joe123@joe.com')
     fill_in('Password', with: '12344321')
     click_button('Log in')
     click_link 'Review KFC'
     expect(page).to have_content('You cannot review your own restaurants')
  end

  def leave_review(thoughts, rating)
    click_link 'Review KFC'
    fill_in 'Thoughts', with: thoughts
    select rating, from: 'Rating'
    click_button 'Leave Review'
  end

  scenario 'displays an average rating for all reviews' do
    visit '/restaurants'
    click_link('Sign up')
    fill_in('Email', with: 'test@example.com')
    fill_in('Password', with: 'testtest')
    fill_in('Password confirmation', with: 'testtest')
    click_button('Sign up')
    leave_review('So so', '3')
    click_link('Sign out')

    click_link('Sign up')
    fill_in('Email', with: 'test2@example.com')
    fill_in('Password', with: 'testtest')
    fill_in('Password confirmation', with: 'testtest')
    click_button('Sign up')

    leave_review('Great', '5')
    expect(page).to have_content('Average rating: ★★★★☆')
  end
end
