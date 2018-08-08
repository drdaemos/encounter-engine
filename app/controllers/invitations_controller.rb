# -*- encoding : utf-8 -*-
class InvitationsController < ApplicationController
  before_action :authenticate_user!

  before_action :build_invitation, :only => [:new, :create]
  before_action :ensure_team_captain, :only => [:new, :create]

  before_action :find_invitation, :only => [:reject, :accept]
  before_action :ensure_recepient, :only => [:reject, :accept]

  def new
    @all_users = User.all
    render
  end

  def create
    if @invitation.save
      send_invitation(@invitation)
      redirect_back :fallback_location => team_path(@invitation.to_team), :notice => "Игроку #{@invitation.for_user.nickname} выслано приглашение"
    else
      @all_users = User.all
      render :new
    end
  end

  def accept
    add_user_to_team_members
    @invitation.delete
    send_accept_notification(@invitation)
    reject_rest_of_invitations

    redirect_to :dashboard
  end

  def reject
    @invitation.delete
    send_reject_notification(@invitation)
    redirect_to :dashboard
  end

  protected

  def send_invitation(invitation)
    begin
      NotificationMailer
          .invitation(:to => invitation.for_user.email,
                      :from => get_from_email,
                      :subject => "Вас пригласили вступить в команду #{invitation.to_team.name}",
                      :team => invitation.to_team,
                      :user => invitation.for_user)
          .deliver_now
    rescue => exception
      logger.error exception.message
    end
  end

  def send_reject_notification(invitation)
    begin
      NotificationMailer
          .reject_invitation(:to => invitation.to_team.captain.email,
                             :from => get_from_email,
                             :subject => "Игрок #{invitation.for_user.nickname} отказался от приглашения",
                             :user => invitation.for_user,
                             :team => invitation.to_team)
          .deliver_now
    rescue => exception
      logger.error exception.message
    end
  end

  def send_accept_notification(invitation)
    begin
      NotificationMailer
          .accept_invitation(:to => invitation.to_team.captain.email,
                             :from => get_from_email,
                             :subject => "Игрок #{invitation.for_user.nickname} принял Ваше приглашение",
                             :user => invitation.for_user,
                             :team => invitation.to_team)
          .deliver_now
    rescue => exception
      logger.error exception.message
    end
  end

  def add_user_to_team_members
    team = @invitation.to_team
    team.members << current_user
  end

  def reject_rest_of_invitations
    Invitation.for(current_user).each do |invitation|
      invitation.delete
      send_reject_notification(invitation)
    end
  end

  def invitation_params
    if params[:invitation].nil?
      return nil
    end

    params[:invitation][:for_user] = User.find params[:invitation][:for_user]
    params[:invitation].permit!
  end

  def get_from_email
    get_setting('site_from') || "autoquest@localhost"
  end

  def build_invitation
    @invitation = Invitation.new(invitation_params)
    @invitation.to_team = current_user.team
  end

  def find_invitation
    @invitation = Invitation.find params[:id]
  end

  def ensure_recepient
    unless current_user.id == @invitation.for_user.id
      raise UnauthorizedError, "Вы должны быть получателем, чтобы выполнить это действие"
    end
  end
end
