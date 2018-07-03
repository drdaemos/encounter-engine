# -*- encoding : utf-8 -*-
class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user, :only => [:show, :update_data, :edit_data]

  def index
    render
  end

  def list
    @users = User.free_players
    render :json => @users.to_a
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
end
