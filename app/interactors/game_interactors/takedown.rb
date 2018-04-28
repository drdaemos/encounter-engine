module GameInteractors
  class Takedown
    include Interactor

    def call
      context.fail! if !context.game.finished? || context.user.nil? || !context.user.can_edit?(context.game)

      game = context.game
      game.is_published = false
      game.save!
    end
  end
end