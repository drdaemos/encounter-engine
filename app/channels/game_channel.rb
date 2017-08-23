class GameChannel < ApplicationCable::Channel
  def subscribed
    # current_user.appear
    stream_from "game_#{params[:game]}_team_#{params[:team]}"
  end

  def unsubscribed
    # current_user.disappear
  end

  def post_answer(data)
    team = Team.find(params[:team])
    game = Game.find(params[:game])
    game_passing = GamePassing.of(team, game)
    unless game_passing.nil? or game_passing.finished?
      answer = data["payload"]["answer"].strip
      save_answer_to_log(answer, team, game)
      answer_was_correct = game_passing.check_answer!(answer)
    end

    ActionCable.server.broadcast("game_#{params[:game]}_team_#{params[:team]}", get_app_data(team, game) )
  end

  def away
    # current_user.away
  end

  def save_answer_to_log (answer, team, game)
    game_passing = GamePassing.of(team, game)
    level = Level.find(game_passing.current_level.id)
    Log.create! :game_id => game.id,
                :level => level.name,
                :team => team.name,
                :time => Time.now,
                :answer => answer
  end

  def get_app_data (team, game)
    game_passing = GamePassing.of(team, game)

    if game_passing.current_level.id
      level = Level.find(game_passing.current_level.id)
      next_hint = game_passing.upcoming_hints.first;

      {
        :user => { :team => team.name, :team_id => team.id, :is_captain => current_user.captain? },
        :game => { :id => game.id, :name => game.name, :is_testing => game.is_testing? },
        :game_passing => { :time => Time.now, :answered => game_passing.answered_questions.size },
        :level => { :id => level.id, :name => level.name, :text => level.text, :position => level.position, :multi_question => level.multi_question?, :question_count => level.questions.count },
        :hints => { 
          :available => game_passing.hints_to_show,
          :next_hint => next_hint.nil? ? nil : next_hint.available_in(game_passing.current_level_entered_at)
        }
      }
    elsif game_passing.finished?
      {
        "finished": true
      }
    end
      
  end
end