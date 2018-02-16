class AbstractView < Cell::ViewModel
  include Cell::Erb
  include ActionView::Helpers::UrlHelper

  def show
    render if is_visible?
  end

  protected

  def get_allowed_targets
    nil
  end

  def is_visible?
    is_allowed_target?
  end

  def is_allowed_target?
    unless get_allowed_targets.nil?
      get_allowed_targets.each_pair do |name, actions|
        return true if controller.controller_name === name.to_s && actions.include?(controller.action_name)
      end

      return false
    end

    true
  end

end