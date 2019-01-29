# To generate this file, do:
# rails g cancan:ability

class Ability
  include CanCan::Ability

  #               👇🏼 will always be passed the `current_user`
  def initialize(user)
    # Inside of this method, `user` is the `current_user`
    # To use cancancan, you must define the `current_user` method
    # in the `ApplicationController`.

    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :manage, :all
    else
      can :read, :all
    end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities

    # Use the `alias_action` method to assign multiple action names
    # to one action alias. The means that alias can be used in
    # place for any of the supllied actions.
    # In this case, :crud be used wherever :create, :read, :update
    # or :delete would be used.

    alias_action(:create, :read, :edit, :update, :delete, to: :crud)

    # To define a permission for a user, use the `can` method
    # inside of this class' `initialize` method. It takes
    # the following args. in order:
    # - The name of action your are testing permission for as a symbol.
    #   (e.g. :crud, :edit, :delete, :like, :favourite)
    # - The class of an object we are testing the action against.
    #   (e.g. Question, Answer, User, etc.)
    # - A block that is used to determine whether or not a user
    #   can perform said action on the resource. If the block
    #   returns `true`, the use can perform the action. Otherwise,
    #   they can't.

    can(:crud, Question) do |question|
      question.user == user
    end

    # can(:edit, Question) do |question|
    #   question.user == user # current_user
    # end
    # If the current user is the owner of the question, he can
    # edit it.
    # can(:edit, Question) do |question|
    #   question.user == user # current_user
    # end
    # don't need to do permission for each action we use a trick
    # and use alias actions
    can(:crud, Answer) do |answer|
      answer.user == user
    end

    can(:crud, JobPost) do |job_post|
      job_post.user == user
    end

    can(:like, Question) do |question|
      # Check to first see if user is signed in
      # We're also doing this with ou authenticate_user
      # though.
      user.persisted? && question.user != user
    end

    can(:destroy, Like) do |like|
      like.user == user
    end
  end
end
