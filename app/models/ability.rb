class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.has_role?('admin')
      can :manage, :all
    elsif user.has_role?('editor')
      can :manage, Edition, state: :draft
      can :manage, Flyby
      can :manage, NewsStory
      can :manage, OrbitDiagram
      can :manage, Source
      can :manage, Theme
      can :read, SocialEngagement
      can :read, User
    elsif user.has_role?('subscriber')
      can :read, Edition, state: :published
      can :share, Edition, state: :published
      can :unsubscribe, User
      can :create, Preference
      can :update, Preference
    else
      can :read, Edition, state: :published
      can :current, Edition, state: :published
      can :share, Edition, state: :published
    end
  end
end
