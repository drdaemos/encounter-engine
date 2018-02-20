module GameStatsPage
  class Heading < AbstractView

    def is_visible?
      super && !model.nil?
    end

    def user_can_edit?
      controller.user_signed_in? && controller.current_user.can_edit?(model)
    end
  end
end