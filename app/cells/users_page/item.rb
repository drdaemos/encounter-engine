module UsersPage
  class Item < AbstractView

    def is_visible?
      super && !model.nil?
    end

    def editable?
      !is_current_user? && (can_edit_access? || can_invite_to_team?)
    end

    def is_current_user?
      controller.user_signed_in? && controller.current_user.id == model.id
    end

    def can_edit_access?
      controller.user_signed_in? && controller.current_user.access_level?(:admin)
    end

    def can_invite_to_team?
      controller.user_signed_in? && controller.current_user.captain?
    end

    def model_can_be_invited?
      can_invite_to_team? && !model.member_of?(controller.current_user.team) && !model_is_invited?
    end

    def model_is_invited?
      can_invite_to_team? && !Invitation.for_user(model).to_team(controller.current_user.team).empty?
    end

    def model_sent_application?
      can_invite_to_team? && !TeamApplication.of_user(model).for_team(controller.current_user.team).empty?
    end

  end
end