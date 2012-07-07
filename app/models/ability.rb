class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.has_role? :admin
      can :manage, :all
    end
    if user.has_role? :functionary
      can :read, Article
      can :update, Functionary
      can :show, InformationPage
      can :read, Participant
      can [:index, :show, :update, :q_status, :resolve], Question
      can :read, Workshop
    end
    if user.has_role? :participant
      can :read, Article
      can :show, InformationPage
      can :show, Workshop
      can [:show, :update, :travel_support, :invitation], Participant
      can [:index, :show, :update, :new, :create], Question
    end
    if user.has_role? :dialogue
      #
    end
    if user.has_role? :sec
      can :manage, Host
      can [:index, :match, :match_host, :check_in, :check_out, :show], Participant
    end
  end

end
