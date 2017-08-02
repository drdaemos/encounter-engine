# -*- encoding : utf-8 -*-
class TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_not_member_of_any_team, :only => [:new, :create]
  before_action :build_team, :only => [:new, :create]

  def new
    render
  end

  def create
    if @team.save
      redirect_to :dashboard
    else
      render :new
    end
  end

protected

  def team_params
    params[:team].permit(:name) unless params[:team].nil?
  end

  def build_team
    @team = Team.new(team_params)
    @team.captain = current_user
  end

  def ensure_not_member_of_any_team
    raise UnauthorizedError, "Вы уже являетесь членом команды" if current_user.member_of_any_team?
  end
end
