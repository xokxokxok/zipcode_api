class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.role.admin?
      can :manage, :all
    elsif user.role.consumer?
      can :manage, User, id: user.id
      can :manage, UserToken
      can :create, Address
    elsif user.role.pending?
      can :manage, User, id: user.id
    else
      cannot :manage, :all
    end
  end
end
