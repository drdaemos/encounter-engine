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

  def request_state()
    perform_checks
    team = Team.find(params[:team])
    game = Game.find(params[:game])
    game_state = get_app_data(team, game)

    ActionCable.server.broadcast("game_#{params[:game]}_team_#{params[:team]}", game_state )
  end

  def post_answer(data)
    perform_checks
    team = Team.find(params[:team])
    game = Game.find(params[:game])
    game_passing = GamePassing.of(team, game)

    message = { :messages => [], :flashes => [] }  

    unless game_passing.nil? or game_passing.finished?
      answer = data["payload"]["answer"].strip
      answer_was_correct = game_passing.check_answer!(answer)
      spoiler_was_correct = game_passing.check_spoiler!(answer)
      message[:messages] << { :answer_result => answer_was_correct, :spoiler_result => spoiler_was_correct }
      type = answer_was_correct ? 'Код' : 'Код спойлера'

      save_answer_to_log(answer, team, game)
      if (answer_was_correct or spoiler_was_correct)
        message[:flashes] << { :text => type + ' ' + answer + ' принят' }
      else
        message[:flashes] << { :text => type + ' ' + answer + ' не принят' }
      end
    end

    game_state = get_app_data(team, game)

    ActionCable.server.broadcast("game_#{params[:game]}_team_#{params[:team]}", game_state.merge(message) )
  end

  def perform_checks
    team = Team.find(params[:team])
    game = Game.find(params[:game])
    game_passing = GamePassing.of(team, game)
    fail_level_if_limit_is_passed(game_passing)
  end 

end