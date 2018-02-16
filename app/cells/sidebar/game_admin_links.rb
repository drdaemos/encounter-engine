module Sidebar
  class GameAdminLinks < AbstractView

    def is_visible?
      super && model.can_edit?(controller.current_user)
    end

    def get_allowed_targets
      {
          :index => ['index'],
          :games => ['show']
      }
    end
  end
end