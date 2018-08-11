# -*- encoding : utf-8 -*-
class TeamApplicationsController < ApplicationController
  before_action :authenticate_user!

  before_action :build_team_application, :only => [:new, :create]
  before_action :find_team_application, :only => [:reject, :accept]
  before_action :ensure_team_captain, :only => [:reject, :accept]

  def new
    @teams = Team.all
    render
  end

  def create
    if @team_application.team.captain.nil?
      @team_application.team.captain = @team_application.user
      @team_application.team.save!
      redirect_back :fallback_location => team_path(@team_application.team)
    elsif @team_application.save
      send_application_notification(@team_application)
      redirect_back :fallback_location => user_path(@team_application.user), :notice => "Команде #{@team_application.team.name} выслан запрос на вступление"
    else
      @teams = Team.all
      render :new
    end
  end

  def accept
    if @team_application.user.captain?
      @team_application.user.team.captain = nil
      @team_application.user.team.save!
    end
    new_player = @team_application.user
    add_user_team_members
    @team_application.delete
    send_accept_notification(@team_application)
    reject_rest_of_team_applications

    redirect_back :fallback_location => team_path(@team_application.team), :notice => "Игрок #{new_player.nickname} принят в команду"
  end

  def reject
    @team_application.delete
    send_reject_notification(@team_application)

    redirect_back :fallback_location => team_path(current_user.team)
  end

protected

  def send_application_notification(team_application)
    begin
      NotificationMailer
        .team_application(:to => team_application.user.email,
              :from => get_from_email,
              :subject => "Игрок #{team_application.user.nickname} подал запрос на вступление в команду #{team_application.team.name}",
              :user => team_application.user,
              :team => team_application.team)
        .deliver_now
    rescue => exception
      logger.error exception.message
    end
  end

  def send_reject_notification(team_application)
    begin
      NotificationMailer
        .reject_application(:to => team_application.user.email,
              :from => get_from_email,
              :subject => "Команда #{team_application.user.nickname} отказала вам",
              :user => team_application.user,
              :team => team_application.team)
        .deliver_now
    rescue => exception
      logger.error exception.message
    end
  end

  def send_accept_notification(team_application)
    begin
      NotificationMailer
        .accept_application(:to => team_application.user.email,
              :from => get_from_email,
              :subject => "Вы приняты в команду #{team_application.team.name}",
              :user => team_application.user,
              :team => team_application.team)
        .deliver_now
    rescue => exception
      logger.error exception.message
    end
  end

  def add_user_team_members
    team = @team_application.team
    team.members << @team_application.user
  end

  def reject_rest_of_team_applications
    TeamApplication.of_user(current_user).each do |team_application|
      team_application.delete
    end
  end

  def team_application_params
    if params[:team_application].nil?
      return nil
    end

    params[:team_application][:team] = Team.find params[:team_application][:team]
    params[:team_application][:user] = current_user
    params[:team_application].permit!
  end

  def get_from_email
    get_setting('site_from') || "autoquest@localhost"
  end

  def build_team_application
    @team_application = TeamApplication.new(team_application_params)
  end

  def find_team_application
    @team_application = TeamApplication.find params[:id]
  end
end
