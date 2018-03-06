module GamePassingInteractors
  class CreatePassing
    include Interactor

    def call
      game_passing = GamePassing.create! :team => context.team,
                                          :game => context.game

      if context.game.started?
        game_passing.current_level = context.game.levels.first
      end

      context.game_passing = game_passing
    end
  end
end