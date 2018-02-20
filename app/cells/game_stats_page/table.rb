module GameStatsPage
  class Table < AbstractView

    def is_visible?
      super && !model.nil?
    end

    def game_passings
      GamePassing.of_game(model)
    end

    def table_rows
      sort_game_passings
    end

    def table_columns
      columns = {
          :team => {
              :label => "Команда",
              :getter => ->(game_passing) {game_passing.team.name}
          }
      }

      level_columns = model.levels.reduce(Hash.new) do |result, level|
        result["level-#{level.position}"] = {
            :label => "#{level.position}. #{level.name}",
            :getter => ->(game_passing) do
              result = LevelResult.of(game_passing, level)
              result.level_time unless result.nil?
            end
        }
        result
      end

      stat_columns = {
          :clean_time => {
              :label => "Чистое время",
              :getter => ->(game_passing) { LevelResult.clean_time(game_passing) }
          },
          :adjustment_time => {
              :label => "Бонус/Штраф",
              :getter => ->(game_passing) { LevelResult.adjustment_time(game_passing) }
          },
          :adjusted_time => {
              :label => "С учетом бонусов",
              :getter => ->(game_passing) { LevelResult.adjusted_time(game_passing) }
          }
      }

      columns.merge(level_columns).merge(stat_columns)
    end

    def sort_game_passings
      game_passings.sort do |left, right|
        if left.finished?
          -1
        elsif right.finished?
          1
        else
          right.current_level.position <=> left.current_level.position
        end
      end
    end

    def user_can_edit?
      controller.user_signed_in? && controller.current_user.can_edit?(model)
    end
  end
end