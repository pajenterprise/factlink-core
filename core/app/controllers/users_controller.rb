class UsersController < ApplicationController
  layout "frontend"

  before_filter :load_user, except: [:current, :tour_users, :seen_messages]

  def show
    authorize! :show, @user

    backbone_responder do
      full_user = interactor :'users/get_full', username: params[:username]
      render json: full_user
    end
  end

  def current
    if current_user
      full_user = interactor :'users/get_full', username: current_user.username
      render json: full_user
    else
      render json: {}
    end
  end

  # TODO: convert this page to backbone
  def edit
    authorize! :access, Ability::FactlinkWebapp
    authorize! :update, @user
  end

  def update
    authorize! :update, @user

    # sometimes it is passed in user, sometimes it isn't :(
    user_hash =  params[:user] || params

    if @user.update_attributes user_hash
      respond_to do |format|
        format.html { redirect_to edit_user_url(@user.username), notice: 'Your account was successfully updated.' }
        format.json { render json: {} }
      end
    else
      respond_to do |format|
        format.html do
          authorize! :access, Ability::FactlinkWebapp
          render :edit
        end
        format.json { render json: { status: :unprocessable_entity } }
      end
    end
  end

  def destroy
    authorize! :destroy, @user

    interactor(:'users/delete', user_id: @user.id,
                                current_user_password: params[:user][:password]) do |delete|

      if delete.valid?
        delete.call
        sign_out
        redirect_to root_path, notice: 'Your account has been deleted.'
      else
        redirect_to edit_user_path(current_user), alert: 'Your account could not be deleted. Did you enter the correct password?'
      end
    end
  end

  def notification_settings
    authorize! :edit_settings, @user
    authorize! :access, Ability::FactlinkWebapp

    backbone_responder
  end

  def seen_messages
    authorize! :update, current_user
    fail HackAttempt unless params[:message] =~ /\A\w+\Z/
    current_user.seen_messages << params[:message]
    render json: {}, status: :ok
  end

  def tour_users
    authorize! :access, Ability::FactlinkWebapp
    # TODO add proper authorization check

    render json: interactor(:"users/tour_users")
  end

  private

  def load_user
    username = params[:username] || params[:id]
    @user = query(:'user_by_username', username: username)
    @user or raise_404
  rescue Pavlov::ValidationError
    raise_404
  end
end
