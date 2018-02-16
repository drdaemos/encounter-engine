module Sidebar
  class Accessories < AbstractView

    def get_allowed_targets
      {
          :index => ['index'],
          :games => ['show']
      }
    end
  end
end