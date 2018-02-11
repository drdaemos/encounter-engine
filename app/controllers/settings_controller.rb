# -*- encoding : utf-8 -*-
class SettingsController < AdminController
  before_action :authenticate_user!

  def index
    @settings = Setting.all
    render
  end

  def update
    params[:settings].each_pair{ |key, value| entity = Setting.find_by_key(key); entity.value = value; entity.save! }
    redirect_back(fallback_location: settings_path)
  end

protected

  def question_params
    params[:settings].permit! unless params[:settings].nil?
  end
end
