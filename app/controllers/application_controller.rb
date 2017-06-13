class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :find_user_from_session

  def logged_in?
    !! @_current_user
  end

protected

  def current_user
    @_current_user ||= session[:current_user_id] &&
      User.find_by(id: session[:current_user_id])
  end

  def find_user_from_session
    @_current_user = current_user
  end  

  def ensure_team_member
    unless current_user.member_of_any_team?
      raise Unauthorized, "Вы не авторизованы для посещения этой страницы"
    end
  end

  def ensure_team_captain
    unless current_user.captain?
      raise Unauthorized, "Вы должны быть капитаном чтобы выполнить это действие"
    end
  end

  def ensure_author
    unless logged_in? and @_current_user.author_of?(@game)
      raise Unauthorized, "Вы должны быть автором игры, чтобы видеть эту страницу"
    end
  end

  def ensure_game_was_not_started
    raise Unauthorized, "Нельзя редактировать игру после её начала" if @game.started?
  end
end
