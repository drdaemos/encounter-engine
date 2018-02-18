module Sidebar
  class GameAdminLinks < AbstractView

    def is_visible?
      super && !model.nil? && controller.user_signed_in? && controller.current_user.can_edit?(model)
    end

    def get_allowed_targets
      {
          :index => ['index'],
          :games => ['show', 'edit']
      }
    end
  end
end