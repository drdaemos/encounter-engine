# -*- encoding : utf-8 -*-
class NotificationMailer < ApplicationMailer

  def welcome_letter(params)
    @email = params[:email]
    @password = params[:password]
    mail :to => params[:to], :from => params[:from], :subject => params[:subject]
  end

  def invitation_notification(params)
    @team = params[:team]
    mail :to => params[:to], :from => params[:from], :subject => params[:subject]
  end

  def reject_notification(params)
    @user = params[:user]
    mail :to => params[:to], :from => params[:from], :subject => params[:subject]
  end

  def accept_notification(params)
    @user = params[:user]
    mail :to => params[:to], :from => params[:from], :subject => params[:subject]
  end
  
end
