# -*- coding: utf-8 -*-

class TeamsController < ApplicationController
  before_filter :ensure_authenticated  
  before_filter :ensure_not_member_of_any_team, :only => [:new, :create]
  before_filter :build_team

  def new
    
  end

  def create
    if @team.save
      redirect url(:dashboard)
    else
      render :new
    end
  end

  protected

  def build_team
    @team = Team.new(params[:team])
    @team.captain = current_user
  end

  def ensure_not_member_of_any_team
    raise Unauthorized, "Вы уже являетесь членом команды" if current_user.member_of_any_team?
  end
end
