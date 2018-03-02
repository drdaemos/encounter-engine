class GameChannel < ApplicationCable::Channel
  include GamePassingsHelper
  
  def subscribed
    # current_user.appear
    stream_from "game_#{params[:game]}_team_#{params[:team]}"
  end

  def unsubscribed
    # current_user.disappear
  end

  def away
    # current_user.away
  end

  def request_state
    team = Team.find(params[:team])
    game = Game.find(params[:game])
    game_passing = GamePassing.of(team, game)
    perform_checks(game_passing)
    game_state = get_app_data(game_passing)

    ActionCable.server.broadcast("game_#{params[:game]}_team_#{params[:team]}", game_state )
  end

  def post_answer(data)
    team = Team.find(params[:team])
    game = Game.find(params[:game])
    game_passing = GamePassing.of(team, game)
    perform_checks(game_passing)

    message = { :messages => [], :flashes => [] }  

    unless game_passing.nil? or game_passing.finished?
      answer = data["payload"]["answer"].strip
      save_answer_to_log(answer, game_passing)
      spoiler_was_correct = game_passing.check_spoiler!(answer)
      answer_was_correct = game_passing.check_answer!(answer)
      message[:messages] << { :answer_result => answer_was_correct, :spoiler_result => spoiler_was_correct }
      type = spoiler_was_correct ? 'Код спойлера' : 'Код'

      if answer_was_correct or spoiler_was_correct
        message[:flashes] << { :text => type + ' ' + answer + ' принят' }
      else
        message[:flashes] << { :text => type + ' ' + answer + ' не принят' }
      end
    end

    perform_post_checks(game_passing)
    game_state = get_app_data(game_passing)

    ActionCable.server.broadcast("game_#{params[:game]}_team_#{params[:team]}", game_state.merge(message) )
  end

end