# -*- encoding : utf-8 -*-
class AnswersController < ApplicationController
  before_action :find_game
  before_action :ensure_author
  before_action :find_level
  before_action :find_question
  before_action :find_answers
  before_action :find_answer, :only => [:destroy]
  before_action :build_answer, :only => [:index, :create]

  def index
    render
  end

  def create
    if @answer.save
      redirect_back :fallback_location => [@level.game, @level]
    else
      render :index
    end
  end

  def destroy
    if @answers.length > 1
      @answer.destroy
      redirect_to [@game, @level, @question, :answers]
    else
      build_answer
      @answer.errors.add(:question, "Должен быть хотя бы один вариант кода")
      render :index
    end
  end

protected

  def answer_params
    params[:answer].permit(:value) unless params[:answer].nil?
  end

  def find_game
    @game = Game.find(params[:game_id])
  end

  def find_level
    @level = Level.find(params[:level_id])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def find_answers
    @answers = Answer.of_question(@question)
  end

  def build_answer
    @answer = Answer.new(answer_params)
    @answer.level = @level
    @answer.question = @question
  end
end
