module GamePassingInteractors
  class CheckAnswer
    include Interactor

    def call
      game_passing = context.game_passing
      answer = context.answer.strip

      unless game_passing.nil? or game_passing.finished?
        level_id = game_passing.current_level.id

        linked_object = nil

        if (spoiler = check_spoiler!(game_passing, answer))
          linked_object = spoiler
        elsif (question = check_answer!(game_passing, answer))
          linked_object = question
        end

        save_answer_to_log(game_passing, level_id, answer, linked_object)
        context.fail! if linked_object.nil?

        context.linked_object = linked_object
      end
    end

    def save_answer_to_log(game_passing, level_id, input, linked_object)
      if level_id
        Log.create! :game_passing => game_passing,
                    :level_id => level_id,
                    :answer => input,
                    :linkable => linked_object
      end
    end

    def check_spoiler!(game_passing, code)
      if game_passing.correct_spoiler_code?(code)
        spoiler = game_passing.current_level.find_hint_by_code(code)
        game_passing.open_spoiler!(spoiler) if spoiler
        return spoiler
      end
      false
    end

    def check_answer!(game_passing, answer)
      if game_passing.correct_answer?(answer)
        answered_question = game_passing.current_level.find_question_by_answer(answer)
        game_passing.pass_question!(answered_question, answer) if answered_question
        game_passing.pass_level! if game_passing.questions_answered?
        return answered_question
      end
      false
    end
  end
end