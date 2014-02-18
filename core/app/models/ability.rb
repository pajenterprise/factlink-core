class Ability
  class AdminArea;end
  class FactlinkWebapp;end


  include CanCan::Ability

  attr_reader :user

  def signed_in?
    !!user
  end

  def set_up?
    signed_in? and user.set_up
  end

  def initialize(user=nil)
    @user=user

    can :show, String do |template|
      ! /^home\/pages\/help/.match template
    end

    if set_up?
      can :access, FactlinkWebapp
      can :show, String
    end

    define_anonymous_user_abilities

    define_feature_toggles

    define_fact_abilities
    define_comment_abilities
    define_sub_comment_abilities
    define_user_abilities
    define_user_activities_abilities
    define_sharing_abilities
  end

  def define_anonymous_user_abilities
    can :get_fact_count, Site
    can :new, Fact
    can :index, Fact
    can :read, Fact
    can :read, Comment

    can :read, User do |u|
      u.active? || u.deleted # we show a special page for deleted users
    end
  end

  def define_fact_abilities
    return unless signed_in?

    can :index, Fact
    can :read, Fact
    can :opinionate, Fact
    can :create, Fact
    cannot :update, Fact
  end

  def define_comment_abilities
    return unless signed_in?

    can :read, Comment
    can :destroy, Comment do |comment|
      dead_comment = Pavlov.query(:'comments/by_ids', ids: comment.id.to_s, pavlov_options: {}).first
      comment.created_by.id == user.id && dead_comment.is_deletable
    end
  end

  def define_sub_comment_abilities
    return unless signed_in?

    can :create, SubComment
    can :destroy, SubComment do |sub_comment|
      sub_comment.created_by_id == user.id
    end
  end

  def define_user_abilities
    return unless signed_in?

    can :read, user
    can :set_up, user

    if set_up?
      if user.admin?
        can :access, AdminArea
        can :configure, FactlinkWebapp
        can :manage, User
        cannot :edit_settings, User
      end

      can :update, user
      can :edit_settings, user
      can :destroy, user
    end
  end

  def define_user_activities_abilities
    return unless signed_in?

    can :index, Activity
    can :see_activities, User do |u|
      u.id == user.id
    end
  end

  def define_sharing_abilities
    return unless signed_in?

    can :share, Fact

    can :share_to, SocialAccount do |social_account|
      social_account.persisted? && social_account.user == user
    end
  end

  FEATURES = %w(
    pink_feedback_button
    memory_profiling
    paragraph_icons
    log_jslib_loading_performance
    opinions_of_users_and_comments
    sidebar_manual_reload
  )

  def enabled_global_features
    Pavlov.interactor :'global_features/all'
  end

  def enable_features list
    list.each do |feature|
      can :"see_feature_#{feature}", FactlinkWebapp
      @features << feature.to_s
    end
  end

  def define_feature_toggles
    @features ||= []
    enable_features enabled_global_features
    if signed_in?
      enable_features user.features
    end
  end

  def feature_toggles
    return @features
  end

end
