# -*- encoding : utf-8 -*-
class AdminController < ApplicationController
  before_action :ensure_access

  def index
    render
  end

protected
  def page_layout
    "admin"
  end

  def ensure_access
    ensure_admin_permissions
  end

  def ensure_admin_permissions
    unless true
      raise UnauthorizedError, "Вам необходимо быть администратором для совершения этого действия"
    end
  end
end
