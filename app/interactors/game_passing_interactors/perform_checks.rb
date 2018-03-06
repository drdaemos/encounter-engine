module GamePassingInteractors
  class PerformChecks
    include Interactor

    def call
      start_game_passing(context.game_passing)
      fail_level_if_limit_is_passed(context.game_passing)
    end

    def start_game_passing (game_passing)
      if game_passing.game.started? && !game_passing.finished? && game_passing.current_level.nil? && !game_passing.game.levels.empty?
        game_passing.current_level = game_passing.game.levels.first
        game_passing.save!
      end
    end

    def fail_level_if_limit_is_passed(game_passing)
      if game_passing.nil? || game_passing.current_level.nil? || game_passing.current_level_entered_at.nil?
        return
      end

      diff = Time.now - game_passing.current_level_entered_at
      if not game_passing.finished? and not game_passing.current_level.nil? and game_passing.current_level.time_limit and diff.to_i > game_passing.current_level.time_limit * 60
        game_passing.fail_level!
      end
    end
  end
end