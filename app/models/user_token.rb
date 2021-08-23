class UserToken < ApplicationRecord
  belongs_to :user

  def expired?
    self.expires_at.to_i > DateTime.now.to_i
  end
end
