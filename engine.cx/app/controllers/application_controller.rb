# -*- coding: utf-8 -*-

class ApplicationController < ActionController::Base
  protect_from_forgery

  include SharedFilters

  def logged_in?
    !! current_user
  end
end
