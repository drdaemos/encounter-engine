class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, prepend: true
  before_action :configure_permitted_parameters, if: :devise_controller?
  layout "application"

protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname, :email])
    devise_parameter_sanitizer.permit(:account_update, keys: [:nickname, :email])
  end

  def ensure_team_member
    unless current_user.member_of_any_team?
      raise UnauthorizedError, "Вы не авторизованы для посещения этой страницы"
    end
  end

  def ensure_team_captain
    unless current_user.captain?
      raise UnauthorizedError, "Вы должны быть капитаном чтобы выполнить это действие"
    end
  end

  def ensure_author
    unless user_signed_in? and current_user.author_of?(@game)
      raise UnauthorizedError, "Вы должны быть автором игры, чтобы видеть эту страницу"
    end
  end

  def ensure_game_was_not_started
    raise UnauthorizedError, "Нельзя редактировать игру после её начала" if @game.started?
  end
end
