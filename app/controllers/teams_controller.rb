# -*- encoding : utf-8 -*-
class TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_not_member_of_any_team, :only => [:new, :create]
  before_action :build_team, :only => [:new, :create]
  before_action :find_team, :only => [:show, :destroy, :edit, :update]

  helper_method :user_can_edit?

  def new
    render
  end

  def index
    @teams = Team.all
    render
  end

  def show
    render
  end

  def edit
    render
  end

  def update
    if @team.update_attributes(team_params)
      redirect_to @team
    else
      render :edit
    end
  end

  def create
    if @team.save
      redirect_back :fallback_location => team_path(@team)
    else
      render :new
    end
  end

  def destroy
    @team.destroy
    redirect_to :dashboard
  end

protected

  def user_can_edit?
    current_user.captain_of?(@team)
  end

  def team_params
    if params[:team].nil?
      return Hash.new
    end

    params[:team].permit!
  end

  def build_team
    @team = Team.new(team_params)
    @team.captain = current_user
  end

  def find_team
    @team = Team.friendly.find(params[:id]) || current_user.team
  end

  def ensure_not_member_of_any_team
    raise UnauthorizedError, "Вы уже являетесь членом команды" if current_user.member_of_any_team?
  end
end
