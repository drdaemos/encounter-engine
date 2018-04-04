module GameStatsPage
  class AdjustmentsTable < AbstractView

    def is_visible?
      super && !model.nil?
    end

    def table_rows
      PassingAdjustment.of_game_passing(model).to_a
    end

    def table_columns
      {
          :type => {
              :label => "Тип",
              :getter => ->(adjustment) { adjustment.adjustment < 0 ? "Штраф" : "Бонус" }
          },
          :reason => {
              :label => "Причина",
              :getter => ->(adjustment) { adjustment.reason }
          },
          :time => {
              :label => "Время",
              :getter => ->(adjustment) { to_human(-adjustment.adjustment) }
          }
      }
    end

    def to_human(diff)
      sign = ""
      if diff < 0
        sign = "-"
      end

      sign + Time.at(diff.abs).utc.strftime("%T")
    end

    def user_can_edit?
      controller.user_signed_in? && controller.current_user.can_edit?(model)
    end
  end
end