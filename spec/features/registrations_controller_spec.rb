require 'rails_helper'

RSpec.describe Devise::RegistrationsController, type: :feature do
  fixtures :users

  describe '#new' do
    context 'is admin' do
      it 'signs me in' do
        visit 'users/sign_up'
        within('#new_user') do
          fill_in 'Name', with: 'new'
          fill_in 'Email', with: 'new@user.com'
          fill_in 'Password', with: 'admin123456'
          fill_in 'Password confirmation', with: 'admin123456'
        end
        click_button 'Register'
        expect(page).to have_content 'Welcome! You have signed up successfully.'
      end
    end
  end
end
