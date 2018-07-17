module TeamsPage
  class Item < AbstractView

    def is_visible?
      super && !model.nil?
    end

    def can_edit?
      controller.user_signed_in? && controller.current_user.captain_of?(model)
    end

    def can_send_application?
      controller.user_signed_in? && !controller.current_user.member_of?(model) && !TeamApplication.exists?(controller.current_user, model)
    end

    def already_sent_application?
      controller.user_signed_in? && !controller.current_user.member_of?(model) && TeamApplication.exists?(controller.current_user, model)
    end

  end
end