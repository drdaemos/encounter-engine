module GameInteractors
  class Finish
    include Interactor

    def call
      unless context.allow == true || context.user.can_edit?(context.game)
        context.fail!
      end

      game = context.game
      game.author_finished_at = Time.now
      game.save!

      game_passings = GamePassing.of_game(game)
      game_passings.each do |gp|
        gp.end!
      end
    end
  end
end