# -*- encoding : utf-8 -*-
class QuestionsController < ApplicationController
  before_action :find_game
  before_action :ensure_author
  before_action :find_level
  before_action :build_question, :only => [:create]
  before_action :find_question, :only => [:destroy, :edit, :update]

  def edit
    render
  end

  def update
    if @question.update(question_params)
      redirect_back :fallback_location => [@level.game, @level]
    else
      render :edit
    end
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

  def destroy
    @question.destroy
    redirect_to [@level.game, @level]
  end

  protected

  def question_params
    if params[:question].nil?
      return nil
    end

    params[:question][:penalty_time] = params[:question][:adjustment_time].to_i.abs

    if !params[:question][:has_adjustment]
      params[:question][:penalty_time] = nil
    elsif params[:question][:type] == "bonus"
      params[:question][:penalty_time] = params[:question][:penalty_time] * -1
    end

    params[:question].permit!
  end

  def find_game
    @game = Game.find(params[:game_id])
  end

  def find_level
    @level = Level.find(params[:level_id])
  end

  def find_question
    @question = Question.find(params[:id])
  end

  def build_question
    @question = Question.new(question_params)
    @question.level = @level
  end
end
