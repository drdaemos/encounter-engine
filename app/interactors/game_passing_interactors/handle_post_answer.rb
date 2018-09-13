module GamePassingInteractors
  class HandlePostAnswer
    include Interactor

    def call
      result = GamePassingInteractors::PostAnswer.call(context)

      message = { :messages => [], :flashes => [] }

      if result.success?
        type = result.linked_object.is_a?(Hint) ? 'Код спойлера' : 'Код'
        game_state = result.app_state
        message[:flashes] << { :text => type + ' ' + context.answer + ' принят' }
      else
        game_state = GamePassingInteractors::GetAppState.call(context).app_state
        message[:flashes] << { :text => 'Код ' + context.answer + ' не принят' }
      end

      context.state_to_render = game_state.merge(message)
    end
  end
end