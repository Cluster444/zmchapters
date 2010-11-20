class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    
    if user.admin?
      can :manage, :all
    else
      can :read, GeographicLocation
      can :read, Chapter
      can :read, User
      can :manage, User, :id => user.id
      can :read, Page
    end
  end
end
