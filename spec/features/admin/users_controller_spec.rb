require 'rails_helper'

RSpec.describe Admin::UsersController, type: :feature do
  fixtures :users

  let(:user) { users.first }

  before do
    login_as(user)
  end

  describe '#show' do
    context 'is admin' do
      it 'signs me in' do
        visit "admin/user/#{user.id}"
        expect(page).to have_content user.name
        expect(page).to have_content user.email
        expect(page).to have_content user.role_text
      end
    end
  end

  describe '#index' do
    context 'is admin' do
      it 'signs me in' do
        visit 'admin/users'
        User.limit(2).each do |user|
          expect(page).to have_content user.email
        end
      end
    end
  end

  describe '#edit' do
    context 'is admin' do
      it 'signs me in' do
        visit "admin/edit/user/#{user.id}"
        within("#edit_user_#{user.id}") do
          fill_in 'Name', with: 'New Name'
        end
        click_button 'Update'
        expect(page).to have_content 'Updated with success!'
      end
    end
  end
end
