# -*- encoding : utf-8 -*-
class TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_not_member_of_any_team, :only => [:new, :create]
  before_action :build_team

  def new
    render
  end

  def create

    @team.captain = current_user
    if @team.save
      redirect url(:dashboard)
    else
      render :new
    end
  end

protected

  def build_team
    @team = Team.new(params[:team])
  end

  def ensure_not_member_of_any_team
    raise Unauthorized, "Вы уже являетесь членом команды" if current_user.member_of_any_team?
  end
end
