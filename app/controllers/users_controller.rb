# -*- encoding : utf-8 -*-
class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user, :only => [:show]

  def index
    render
  end

  def list
    @users = User.free_players
    render :json => @users.to_a
  end

  def show
    render
  end

protected

  def find_user
    @user = User.friendly.find(params[:id])
  end
end
