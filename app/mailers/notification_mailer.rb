# -*- encoding : utf-8 -*-
class NotificationMailer < ApplicationMailer

  def welcome_letter(params)
    @email = params[:email]
    @password = params[:password]
    mail :to => params[:to], :from => params[:from], :subject => params[:subject]
  end

  def invitation(params)
    generic_invitation(params)
  end

  def reject_invitation(params)
    generic_invitation(params)
  end

  def accept_invitation(params)
    generic_invitation(params)
  end

  def team_application(params)
    generic_invitation(params)
  end

  def accept_application(params)
    generic_invitation(params)
  end

  def reject_application(params)
    generic_invitation(params)
  end

  protected

  def generic_invitation(params)
    @user = params[:user]
    @team = params[:team]
    mail :to => params[:to], :from => params[:from], :subject => params[:subject]
  end
  
end
