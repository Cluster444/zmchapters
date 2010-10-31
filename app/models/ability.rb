class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    can :manage, :all

    if user.is? :admin
      can :manage, :all
    else
      can :read, Chapter
      can :read, GeographicTerritory
    end
  end
end
