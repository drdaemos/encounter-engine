module Sidebar
  class DashboardLinks < AbstractView

    def is_visible?
      super && controller.user_signed_in?
    end

    def get_allowed_targets
      {
          :dashboard => ['index'],
          :games => ['index'],
      }
    end
  end
end