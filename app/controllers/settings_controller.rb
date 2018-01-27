# -*- encoding : utf-8 -*-
class SettingsController < AdminController
  before_action :authenticate_user!

  def index
    @settings = Setting.all
    render
  end

  def update

  end

protected
end
