# -*- coding: utf-8 -*-

class TeamsController < ApplicationController
  before_filter :ensure_authenticated  
  before_filter :ensure_not_member_of_any_team, :only => [:new, :create]
  before_filter :build_team

  def new
    
  end

  def create
    @team.members.inspect
    if @team.save
      redirect_to dashboard_url
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
    raise "Вы уже являетесь членом команды" if current_user.member_of_any_team?
  end
end
