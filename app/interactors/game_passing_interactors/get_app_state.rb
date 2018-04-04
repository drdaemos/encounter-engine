module GamePassingInteractors
  class GetAppState
    include Interactor

    def call
      current_user = context.user
      game_passing = context.game_passing
      game = game_passing.game
      team = game_passing.team

      if not game_passing.current_level.nil?
        level = Level.find(game_passing.current_level.id)
        next_hint = game_passing.upcoming_hints.first

        context.app_state = {
            :user => { :team => team.name, :team_id => team.id, :is_captain => current_user.captain? },
            :game => { :id => game.id, :name => game.name, :is_testing => game.is_testing?, :started => game.started? },
            :game_passing => { :finished => game_passing.finished?, :time => Time.now.utc, :answered => game_passing.answered_questions.size },
            :level => { :id => level.id, :name => level.name, :text => level.text, :entered_at => game_passing.current_level_entered_at, :position => level.position, :multi_question => level.multi_question?, :question_count => level.question_count, :time_limit => (level.time_limit.to_i) },
            :hints => {
                :available => game_passing.hints_to_show,
                :next_hint => next_hint.nil? ? nil : next_hint.availability_date(game_passing.current_level_entered_at).utc
            }
        }
      elsif game_passing.finished?
        context.app_state = {
            :game_passing => { :finished => game_passing.finished? },
        }
      else
        context.app_state = {
            :user => { :team => team.name, :team_id => team.id, :is_captain => current_user.captain? },
            :game => { :id => game.id, :name => game.name, :description => game.description, :is_testing => game.is_testing?, :starts_at => game.starts_at.utc, :started => game.started? },
            :game_passing => { :finished => game_passing.finished? },
        }
      end
    end
  end
end