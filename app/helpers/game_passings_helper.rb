# -*- encoding : utf-8 -*-
module GamePassingsHelper
  def answer_posted?
    ! @answer.nil?
  end

  def answer_was_correct?
    !! @answer_was_correct
  end

  def get_current_level_tip_data (game_passing)
    next_hint = game_passing.upcoming_hints.first; # next_hint  ?

    { :hint_num => game_passing.hints_to_show.length,
      :hint_text => game_passing.hints_to_show.last.text,
      :next_available_in => next_hint.nil? ? nil : next_hint.available_in(game_passing.current_level_entered_at) }
  end

  def save_answer_to_log (answer, team, game)
    game_passing = GamePassing.of(team, game)    
    if game_passing.current_level.id
        level = Level.find(game_passing.current_level.id)
        Log.create! :game_id => game.id,
                    :level => level.name,
                    :team => team.name,
                    :time => Time.now,
                    :answer => answer
    end
  end

  def get_app_data (team, game)
    game_passing = GamePassing.of(team, game)

    if not game_passing.current_level.nil?
      level = Level.find(game_passing.current_level.id)
      next_hint = game_passing.upcoming_hints.first;

      {
        :user => { :team => team.name, :team_id => team.id, :is_captain => current_user.captain? },
        :game => { :id => game.id, :name => game.name, :is_testing => game.is_testing? },
        :game_passing => { :finished => game_passing.finished?, :time => Time.now.utc, :answered => game_passing.answered_questions.size },
        :level => { :id => level.id, :name => level.name, :text => level.text, :entered_at => game_passing.current_level_entered_at, :position => level.position, :multi_question => level.multi_question?, :question_count => level.questions.count, :time_limit => level.time_limit * 60 },
        :hints => { 
          :available => game_passing.hints_to_show,
          :next_hint => next_hint.nil? ? nil : next_hint.availability_date(game_passing.current_level_entered_at).utc
        }
      }
    elsif game_passing.finished?
      {
        :game_passing => { :finished => game_passing.finished?},
      }
    end
      
  end

  def fail_level_if_limit_is_passed(game_passing)
    diff = Time.now - game_passing.current_level_entered_at
    if not game_passing.finished? and not game_passing.current_level.nil? and game_passing.current_level.time_limit and diff.to_i > game_passing.current_level.time_limit * 60
      game_passing.fail_level!
    end
  end
end
