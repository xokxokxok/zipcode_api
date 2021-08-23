require 'rails_helper'

RSpec.describe Devise::SessionsController, type: :feature do
  fixtures :users

  describe '#new' do
    context 'is admin' do
      it 'signs me in' do
        visit 'users/sign_in'
        within('#new_user') do
          fill_in 'Email', with: users.first.email
          fill_in 'Password', with: 'admin123456'
        end
        click_button 'Login'
        expect(page).to have_content 'Signed in successfully.'
      end
    end
  end

  describe '#destroy' do
    before do
      login_as(users.first)
    end

    it 'signs me out' do
      visit 'admin/users'
      click_link 'Logout'
      expect(page).to have_content 'Signed out successfully.'
    end
  end
end
