module GamePassingInteractors
  class PerformChecks
    include Interactor

    def call
      start_game_passing(context.game_passing)
      fail_level_if_limit_is_passed(context.game_passing)
    end

    def start_game_passing (game_passing)
      if game_passing.game.started? && !game_passing.finished? && game_passing.current_level.nil? && !game_passing.game.levels.empty?
        game_passing.start_game!
      end
    end

    def fail_level_if_limit_is_passed(game_passing)
      if game_passing.nil? || game_passing.current_level.nil? || game_passing.current_level_entered_at.nil?
        return
      end

      fast_forward_levels(game_passing)
    end

    def fast_forward_levels (game_passing)
      current = game_passing.current_level_entered_at

      loop do
        diff = Time.now - current

        if not game_passing.finished? and
           not game_passing.current_level.nil? and
           game_passing.current_level.time_limit and
           diff.to_i > game_passing.current_level.time_limit.to_i

          current += game_passing.current_level.time_limit
          game_passing.fail_level! (current)
        else
          break
        end

      end
    end
  end
end