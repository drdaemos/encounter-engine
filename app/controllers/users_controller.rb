# -*- encoding : utf-8 -*-
class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_not_captain, :only => [:leave_team]
  before_action :find_user, :only => [:show, :update_data, :edit_data, :leave_team]

  def index
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
