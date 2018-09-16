# -*- encoding : utf-8 -*-
class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_not_captain, :only => [:leave_team]
  before_action :ensure_admin, :only => [:set_access_admin, :set_access_organizer, :set_access_player]
  before_action :find_user, :except => [:index, :list]

  helper_method :get_index_limit, :get_index_offset, :get_current_page

  def index
    @users = User.all
    @visible_users = @users.limit(get_index_limit).offset(get_index_offset)
    render
  end

  def list
    @users = User.free_players
    render :json => @users.to_a
  end

  def leave_team
    if @user.member_of_any_team?
      @user.team.members.delete(@user)
      redirect_back :fallback_location => dashboard_path
    end
  end

  def set_access_admin
    change_user_access_level :admin
    redirect_back :fallback_location => users_path
  end

  def set_access_organizer
    change_user_access_level :organizer
    redirect_back :fallback_location => users_path
  end

  def set_access_player
    change_user_access_level :player
    redirect_back :fallback_location => users_path
  end

  def update_data
    if @user.update_attributes(user_params)
      redirect_to @user
    else
      render :edit_data
    end
  end

  def show
    if is_current_user?(@user)
    redirect_to :dashboard
    else
      render
    end
  end

  def edit_data
    render
  end

protected

  def get_current_page
    params.has_key?(:page) ? Integer(params[:page]) : 1
  end

  def get_index_limit
    10
  end

  def get_index_offset
    (get_current_page - 1) * get_index_limit
  end

  def change_user_access_level (level)
    @user.access_level = [level]
    @user.save!
  end

  def user_params
    if params[:user].nil?
      return Hash.new
    end

    params[:user].permit!
  end

  def find_user
    @user = User.friendly.find(params[:id])
  end

  def ensure_not_captain
    raise UnauthorizedError, "Вы не можете покинуть команду, будучи ее капитаном" if current_user.member_of_any_team? && current_user.captain?
  end
end
