# -*- coding: utf-8 -*-

class ApplicationController < ActionController::Base
  protect_from_forgery

  include SharedFilters

  rescue_from Unauthorized, :with => :unauthorized

  def unauthorized(exception)
    render :text => exception.message
  end

  def logged_in?
    !! current_user
  end
end
