class Address < ApplicationRecord
  has_and_belongs_to_many :users

  validates_uniqueness_of :zip_code
  validates_presence_of :zip_code, :address, :neighborhood, :city, :state, :country
end
