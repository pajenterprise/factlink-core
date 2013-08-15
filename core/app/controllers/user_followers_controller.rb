class UserFollowersController < ApplicationController
  before_filter :set_user_name

  def index
    params[:skip] ||= 0
    @skip = params[:skip].to_i

    params[:take] ||= 99999 # 'infinite'
    @take = params[:take].to_i

    @users, @total, @followed_by_me = interactor(:'users/followers', user_name: @user_name,
                                                     skip: @skip, take: @take)

    render 'users/followers/index', format: 'json'
  end

  def update
    follower_username = params[:id]
    interactor :'users/follow_user', user_name: follower_username,
                   user_to_follow_user_name: @user_name
    mp_track 'User: Followed',
      followed: following_username
    render json: {}
  end

  def destroy
    follower_username = params[:id]
    interactor :'users/unfollow_user', user_name: follower_username,
                   user_to_unfollow_user_name: @user_name
    mp_track 'User: Unfollowed',
      unfollowed: following_username
    render json: {}
  end

  private

  def set_user_name
    @user_name = params[:username]
  end
end
