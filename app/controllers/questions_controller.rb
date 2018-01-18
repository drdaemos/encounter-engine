# -*- encoding : utf-8 -*-
class QuestionsController < AdminController
  before_action :find_game
  before_action :ensure_author
  before_action :find_level
  before_action :build_question, :only => [:new, :create]

  def new
    render
  end

  def create
    if @question.save
      @answer = @question.answers.first
      if @answer.save
        redirect_to [@level.game, @level]
      else
        @question.destroy
        build_question
        render :new
      end
    else
      render :new
    end
  end

protected

  def question_params
    params[:question].permit(:correct_answer) unless params[:question].nil?
  end

  def find_game
    @game = Game.find(params[:game_id])
  end

  def find_level
    @level = Level.find(params[:level_id])
  end

  def build_question
    @question = Question.new(question_params)
    @question.level = @level
  end
end
