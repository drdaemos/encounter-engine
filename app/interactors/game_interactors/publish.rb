module GameInteractors
  class Publish
    include Interactor

    def call
      context.fail! if !context.game.finished? || !context.user.can_edit?(context.game)

      game = context.game
      game.is_published = true
      game.save!
    end
  end
end