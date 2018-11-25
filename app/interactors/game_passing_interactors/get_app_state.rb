module GamePassingInteractors
  class GetAppState
    include Interactor

    def call
      current_user = context.user
      game_passing = context.game_passing
      game = game_passing.game
      team = game_passing.team

      if not game_passing.current_level.nil?
        level = Level.find(game_passing.current_level.id)

        context.app_state = {
            :user => { :team => team.name, :team_id => team.id, :is_captain => current_user.captain? },
            :game => { :id => game.id, :name => game.name, :is_testing => game.is_testing?, :starts_at => get_time_to_game_start(game), :started => game.started? },
            :game_passing => { :finished => game_passing.finished?, :time => Time.now.utc, :answered => game_passing.answered_questions.size },
            :level => { :id => level.id, :name => level.name, :text => level.text, :entered_at => get_time_from_level_start(game_passing), :position => level.position, :multi_question => level.multi_question?, :question_count => level.question_count, :time_limit => (level.time_limit.to_f * 1000), :time_left => get_time_to_next_level(game_passing, level) },
            :questions => {
                :count => level.question_count,
                :answered => Log.of(game_passing, level)
            },
            :hints => {
                :available => game_passing.hints_to_show,
                :next_hint => get_time_to_next_hint(game_passing)
            }
        }
      elsif game_passing.finished?
        context.app_state = {
            :game_passing => { :finished => game_passing.finished? }
        }
      else
        context.app_state = {
            :user => { :team => team.name, :team_id => team.id, :is_captain => current_user.captain? },
            :game => { :id => game.id, :name => game.name, :description => game.description, :is_testing => game.is_testing?, :starts_at => get_time_to_game_start(game), :started => game.started? },
            :game_passing => { :finished => game_passing.finished? },
        }
      end

      context.app_state[:timestamp] = Time.now.utc
    end

    def get_time_to_next_hint (game_passing)
      next_hint = game_passing.upcoming_hints.first

      if next_hint.nil?
        return nil
      end

      (next_hint.availability_date(game_passing.current_level_entered_at) - Time.now).to_f * 1000
    end

    def get_time_to_game_start (game)
      (game.starts_at - Time.now).to_f * 1000
    end

    def get_time_from_level_start (game_passing)
      game_passing.time_on_level.to_f * 1000
    end

    def get_time_to_next_level (game_passing, current_level)
      ((game_passing.current_level_entered_at + current_level.time_limit.to_i) - Time.now).to_f * 1000
    end
  end
end