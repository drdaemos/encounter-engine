# -*- coding: utf-8 -*-
class InvitationsController < ApplicationController
  before_filter :ensure_authenticated

  before_filter :build_invitation, :only => [:new, :create]
  before_filter :ensure_team_captain, :only => [:new, :create]

  before_filter :find_invitation, :only => [:reject, :accept]
  before_filter :ensure_recepient, :only => [:reject, :accept]

  def new
    @all_users = User.find :all
  end

  def create
    if @invitation.save
      redirect_to new_invitation_path, :notice => "Пользователю #{@invitation.recepient_nickname} выслано приглашение"
    else
      @all_users = User.find :all
      render :new
    end
  end

  def accept
    add_user_to_team_members

    @invitation.delete

    reject_rest_of_invitations    

    redirect url(:dashboard)
  end

  def reject    
    @invitation.delete
    redirect url(:dashboard)
  end

protected

  def add_user_to_team_members
    team = @invitation.to_team
    team.members << @current_user
  end
  
  def reject_rest_of_invitations
    Invitation.for(@current_user).each do |invitation|
      invitation.delete
      send_reject_notification(invitation)
    end
  end

  def build_invitation
    @invitation = Invitation.new(params[:invitation])
    @invitation.to_team = @current_user.team
  end

  def find_invitation    
    @invitation = Invitation.find params[:id]
  end

  def ensure_recepient
    unless @current_user.id == @invitation.for_user.id
      raise Unauthorized, "Вы должны быть получателем приглашения чтобы выполнить это действие"
    end
  end
end
