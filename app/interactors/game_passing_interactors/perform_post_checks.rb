module GamePassingInteractors
  class PerformPostChecks
    include Interactor

    def call
      finish_game(context.game_passing)
    end

    def finish_game (game_passing)
      game = game_passing.game
      passings = GamePassing.of_game(game)
      if game.started? && !game.finished? && passings.count > 0 && passings.all? { |passing| passing.finished? }
        game.finish_game!
      end
    end
  end
end