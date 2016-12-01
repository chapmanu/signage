class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    alias_action :read, :play, :to => :view

    # Privileged users can do these things
    if user.super_admin?
        can :manage, :all
    end

    can :manage, Slide do |slide|
        slide.users.include?(user)
    end
    
    can :manage, Sign do |sign|
        sign.users.include?(user)
    end

    # All users can do these things
    can :create, Sign
    can :view, Sign, :visibility => 'listed'
    can [:read, :create, :preview, :send_to_sign], Slide

    # See the wikis for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
    # https://github.com/CanCanCommunity/cancancan/wiki/Ability-Precedence
  end
end
