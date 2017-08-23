# -*- encoding : utf-8 -*-
module GamePassingsHelper
  def answer_posted?
    ! @answer.nil?
  end

  def answer_was_correct?
    !! @answer_was_correct
  end

  def save_log
    if @game_passing.current_level.id
      @level = Level.find(@game_passing.current_level.id)
      Log.create! :game_id => @game.id,
                  :level => @level.name,
                  :team => @team.name,
                  :time => Time.now,
                  :answer => @answer
    end
  end

  def app_data
    if @game_passing.current_level.id
      @level = Level.find(@game_passing.current_level.id)
      next_hint = @game_passing.upcoming_hints.first;

      {
        :user => { :team => @team.name, :team_id => @team.id, :is_captain => current_user.captain? },
        :game => { :id => @game.id, :name => @game.name, :is_testing => @game.is_testing? },
        :game_passing => { :time => Time.now, :answered => @game_passing.answered_questions.size },
        :level => { :id => @level.id, :name => @level.name, :text => @level.text, :position => @level.position, :multi_question => @level.multi_question?, :question_count => @level.questions.count },
        :hints => { 
          :available => @game_passing.hints_to_show,
          :next_hint => next_hint.nil? ? nil : next_hint.available_in(@game_passing.current_level_entered_at)
        }
      }
    end 
  end

  def find_game
    @game = Game.find params[:game_id]
  end

  def find_game_by_id
    @game = Game.find(params[:id])
  end

  # TODO: must be a critical section, double creation is possible!
  def find_or_create_game_passing
    @game_passing = GamePassing.of(@team, @game)

    if @game_passing.nil?
      @game_passing = GamePassing.create! :team => @team,
        :game => @game,
        :current_level => @game.levels.first
    end
  end

  def find_team
    @team = current_user.team
  end
end
