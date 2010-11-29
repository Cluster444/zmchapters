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
      can :update, user
      can :read, Page
      can :create, FeedbackRequest
    end

    if user.new_record? and registration_open?
      can :create, User
    end
  end

private
  
  def registration_open?
    option = SiteOption.find_by_key(:site_registration)
    if option.nil?
      false
    else
      option.value == "open"
    end
  end
end
