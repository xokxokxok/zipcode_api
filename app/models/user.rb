class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  extend Enumerize
  enumerize :role, scope: true, in: {
    admin:    :admin,
    consumer: :consumer,
    pending: :pending,
    blocked:  :blocked
  }, default: :consumer


  has_many :user_tokens
  has_and_belongs_to_many :addresses


  validates_uniqueness_of :email
  validates_presence_of :name, :email, :role

  def admin?
    self.role.admin? rescue false
  end

  def consumer?
    self.role.consumer? rescue false
  end

  def pending?
    self.role.pending? rescue false
  end

  def blocked?
    self.role.blocked? rescue false
  end
end
