class GameChannel < ApplicationCable::Channel
  def subscribed
    # current_user.appear
    stream_from get_channel
  end

  def unsubscribed
    # current_user.disappear
  end

  def away
    # current_user.away
  end

  def request_state
    game_state = GamePassingInteractors::UpdateState.call(get_context).app_state

    ActionCable.server.broadcast(get_channel, game_state)
  end

  def post_answer(data)
    answer = data["payload"]["answer"].strip
    context = get_context.merge({:answer => answer})
    result = GamePassingInteractors::PostAnswer.call(context)
    message = { :messages => [], :flashes => [] }

    if result.success?
      type = result.linked_object.is_a?(Hint) ? 'Код спойлера' : 'Код'
      game_state = result.app_state
      message[:flashes] << { :text => type + ' ' + answer + ' принят' }
    else
      game_state = GamePassingInteractors::GetAppState.call(context).app_state
      message[:flashes] << { :text => 'Код ' + answer + ' не принят' }
    end

    ActionCable.server.broadcast(get_channel, game_state.merge(message))
  end

  protected

  def get_channel
    "game_#{params[:game]}_team_#{params[:team]}"
  end

  def get_context
    team = Team.find(params[:team])
    game = Game.find(params[:game])
    game_passing = GamePassing.of(team, game)
    {
      :game_passing => game_passing,
      :user => current_user
    }
  end
end