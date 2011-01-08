class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    
    can :manage, :all and return if user.admin?
    if user.new_record?
      can :create, User if registration_open?
      can :create, Feedback if feedback_public?
    elsif user.coordinator?
      coordinator = Coordinator.find_by_user_id user.id
      can :manage, Link, :linkable => coordinator.chapter
      can :manage, Task, :taskable => coordinator.chapter
      can :manage, Event, :plannable => coordinator.chapter
      can :create, Feedback
    else
      can :update, user
      can :join_chapter, user
      can :create, Feedback if feedback_open?
      can :read, Feedback, :user_id => user.id
    end
    can :read, Chapter
    can :read, Coordinator
    can :read, Event
    can :read, Location
    can :read, Link
    can :read, Page
    can :read, Task
    can :read, User
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

  def feedback_public?
    option = SiteOption.find_by_key(:feedback_status)
    if option.nil?
      false
    else
      option.value == "public" || option.value == "open"
    end
  end

  def feedback_open?
    option = SiteOption.find_by_key(:feedback_status)
    if option.nil?
      false
    else
      option.value == "open"
    end
  end
end
