module Promo
  class TopBanner < AbstractView

    def is_visible?
      super && !controller.user_signed_in?
    end

    def get_allowed_targets
      {
          :index => ['index']
      }
    end
  end
end