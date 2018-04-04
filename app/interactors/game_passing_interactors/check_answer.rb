module GamePassingInteractors
  class CheckAnswer
    include Interactor

    def call
      game_passing = context.game_passing
      answer = context.answer.strip

      unless game_passing.nil? or game_passing.finished?
        save_answer_to_log(game_passing, answer)

        context.spoiler_was_correct = check_spoiler!(game_passing, answer)
        context.answer_was_correct = check_answer!(game_passing, answer)
        context.fail! if (!context.spoiler_was_correct && !context.answer_was_correct)
      end
    end

    def save_answer_to_log(game_passing, answer)
      game = game_passing.game
      team = game_passing.team

      if game_passing.current_level.id
        level = Level.find(game_passing.current_level.id)
        Log.create! :game_id => game.id,
                    :level => level.name,
                    :team => team.name,
                    :time => Time.now,
                    :answer => answer
      end
    end

    def check_spoiler!(game_passing, code)
      if game_passing.correct_spoiler_code?(code)
        spoiler = game_passing.current_level.find_hint_by_code(code)
        game_passing.open_spoiler!(spoiler) if spoiler
        return true
      end
      false
    end

    def check_answer!(game_passing, answer)
      if game_passing.correct_answer?(answer)
        answered_question = game_passing.current_level.find_question_by_answer(answer)
        game_passing.pass_question!(answered_question, answer) if answered_question
        game_passing.pass_level! if game_passing.questions_answered?
        return true
      end
      false
    end
  end
end