class UserAddress < ApplicationRecord
  self.table_name = "addresses_users"

  belongs_to :address
  belongs_to :user
end
