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
              :getter => ->(game_passing) { link_to(game_passing.team.name, game_passing.team) }
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

      interactor = GameInteractors::CalculateTimings

      stat_columns = {
          :clean_time => {
              :label => "Чистое время",
              :getter => ->(game_passing) { interactor.call({:game_passing => game_passing}).clean_time }
          },
          :adjustment_time => {
              :label => "Штраф (+) / Бонус (-)",
              :getter => ->(game_passing) { interactor.call({:game_passing => game_passing}).adjustment_time }
          },
          :adjusted_time => {
              :label => "Итоговое время",
              :getter => ->(game_passing) { interactor.call({:game_passing => game_passing}).adjusted_time }
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