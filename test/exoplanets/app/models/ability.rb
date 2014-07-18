class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    # if user.has_role? :superuser
    if user.has_role? :admin
      can :manage, :all
    end
  end
end
