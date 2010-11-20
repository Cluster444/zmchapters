class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    
    if user.admin?
      can :manage, :all
    else
      can :create, User if user.new_record? and registration_open?
      can :read, GeographicLocation
      can :read, Chapter
      can :read, User
      can :update, User, :id => user.id
      can :read, Page
    end
  end

private
  
  def registration_closed?
    false
  end

  def registration_open?
    !registration_closed?
  end
end
