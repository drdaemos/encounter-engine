# -*- encoding : utf-8 -*-
class AdminController < ApplicationController
  before_action :ensure_admin

  def index
    render
  end

protected
  def page_layout
    "admin"
  end
end
