class ApplicationController < ActionController::Base
  include ApplicationHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Context
  protect_from_forgery with: :exception, prepend: true
  before_action :configure_permitted_parameters, if: :devise_controller?
  layout :page_layout

  helper_method :error_messages_for
  helper_method :datetime
  helper_method :render_sidebar?
  helper_method :is_current_user?

  def error_messages_for(*objects)
    options = objects.extract_options!
    options[:message] ||= I18n.t(:"activerecord.errors.message", :default => "Correct the following errors and try again.")
    messages = objects.compact.map { |o| o.errors.full_messages }.flatten
    unless messages.empty?
      list_items = messages.map { |msg| content_tag(:li, msg) }
      content_tag(:div, :class => "form-error-messages alert") do
        content_tag(:p, options[:message]) + content_tag(:ul, list_items.join.html_safe)
      end
    end
  end

protected

  def page_layout
    "website"
  end

  def render_sidebar?
    !self.is_a? DeviseController
  end

  def is_current_user?(user)
    user_signed_in? && current_user.id == user.id
  end

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

  def ensure_admin
    unless user_signed_in? && current_user.access_level?(:admin)
      raise UnauthorizedError, "Вы должны быть администратором, чтобы видеть эту страницу"
    end
  end

  def ensure_author
    unless user_signed_in? && current_user.can_edit?(@game)
      raise UnauthorizedError, "Вы должны быть автором игры, чтобы видеть эту страницу"
    end
  end

  def ensure_game_was_not_started
    # raise UnauthorizedError, "Нельзя редактировать игру после её начала" if @game.started? and !@game.is_draft?
  end
end
