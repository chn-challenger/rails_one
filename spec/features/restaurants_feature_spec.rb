require 'rails_helper'

feature 'restaurants' do
  context 'no restaurants have been added' do
    scenario 'should display a prompt to add a restaurant' do
      visit '/restaurants'
      expect(page).to have_content 'No restaurants yet'
      expect(page).to have_link 'Add a restaurant'
    end
  end

  context 'restaurants have been added' do
    before do
      user = User.create(email: 'joe123@joe.com',
        password: '12344321', password_confirmation: '12344321')
      user.restaurants.create(name: 'KFC')
    end

    scenario 'display restaurants' do
      visit '/restaurants'
      expect(page).to have_content('KFC')
      expect(page).not_to have_content('No restaurants yet')
    end
  end

  context 'creating restaurants' do
    scenario 'prompts user to fill out a form, then displays the new restaurant' do
      visit '/restaurants'
      click_link('Sign up')
      fill_in('Email', with: 'test@example.com')
      fill_in('Password', with: 'testtest')
      fill_in('Password confirmation', with: 'testtest')
      click_button('Sign up')
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq '/restaurants'
    end

    it 'does not let you submit a name that is too short' do
      visit '/restaurants'
      click_link('Sign up')
      fill_in('Email', with: 'test@example.com')
      fill_in('Password', with: 'testtest')
      fill_in('Password confirmation', with: 'testtest')
      click_button('Sign up')
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'kf'
      click_button 'Create Restaurant'
      expect(page).not_to have_css 'h2', text: 'kf'
      expect(page).to have_content 'error'
    end
  end

  context 'viewing restaurants' do
    let!(:user){User.create(email: 'joe123@joe.com',
        password: '12344321', password_confirmation: '12344321')}
    let!(:kfc){user.restaurants.create(name:'KFC') }

    scenario 'lets a user view a restaurant' do
     visit '/restaurants'
     click_link 'KFC'
     expect(page).to have_content 'KFC'
     expect(current_path).to eq "/restaurants/#{kfc.id}"
    end
  end

  context 'editing restaurants' do
    let!(:user){User.create(email: 'joe123@joe.com',
        password: '12344321', password_confirmation: '12344321')}
    let!(:kfc){user.restaurants.create(name:'KFC') }

    scenario 'let owner edit restaurant' do
      visit '/restaurants'
      click_link('Sign in')
      fill_in('Email', with: 'joe123@joe.com')
      fill_in('Password', with: '12344321')
      click_button('Log in')
      click_link 'Edit KFC'
      fill_in 'Name', with: 'Kentucky Fried Chicken'
      fill_in 'Description', with: 'Deep fried crap'
      click_button 'Update Restaurant'
      expect(page).to have_content 'Kentucky Fried Chicken'
      expect(page).to have_content 'Deep fried crap'
      expect(current_path).to eq '/restaurants'
    end

    scenario 'non-owner cannot edit the restaurant' do
      visit '/restaurants'
      click_link('Sign up')
      fill_in('Email', with: 'test@example.com')
      fill_in('Password', with: 'testtest')
      fill_in('Password confirmation', with: 'testtest')
      click_button('Sign up')
      visit '/restaurants'
      visit "/restaurants/#{kfc.id}/edit"
      expect(page).not_to have_link 'Edit KFC'
      expect(page).to have_content 'You can only edit your own restaurant'
      expect(current_path).to eq '/restaurants'
    end
  end

  context 'deleting restaurants' do
    scenario 'removes a restaurant when a user clicks a delete link' do
      visit '/restaurants'
      click_link('Sign up')
      fill_in('Email', with: 'test@example.com')
      fill_in('Password', with: 'testtest')
      fill_in('Password confirmation', with: 'testtest')
      click_button('Sign up')
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
      click_link 'Delete KFC'
      expect(page).not_to have_content 'KFC'
      expect(page).to have_content 'Restaurant deleted successfully'
    end

    scenario 'another user cannot delete the restaurant' do
      user = User.create(email: 'joe123@joe.com',
        password: '12344321', password_confirmation: '12344321')
      kfc = user.restaurants.create(name: 'KFC')
      visit '/restaurants'
      click_link('Sign up')
      fill_in('Email', with: 'joe@joe.com')
      fill_in('Password', with: 'testtest1')
      fill_in('Password confirmation', with: 'testtest1')
      click_button('Sign up')
      expect(page).not_to have_link 'Delete KFC'
      page.driver.submit :delete, "/restaurants/#{kfc.id}",{}
      expect(page).to have_content 'You only delete your own restaurants'
    end
  end

end
