module Sidebar
  class DashboardLinks < AbstractView

    def is_visible?
      super && controller.user_signed_in?
    end

    def can_create_game?
      controller.current_user.access_level?(:admin) || controller.current_user.access_level?(:organizer)
    end

    def get_allowed_targets
      {
          :dashboard => ['index'],
          :games => ['index'],
      }
    end
  end
end