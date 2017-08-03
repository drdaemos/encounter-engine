# -*- encoding : utf-8 -*-
class LevelsController < ApplicationController
  before_action :find_game
  before_action :ensure_author
  before_action :ensure_game_was_not_started, :only => [:new, :create, :edit, :update, :destroy]
  before_action :build_level, :only => [:new, :create]
  before_action :find_level, :except => [:new, :create]

  def new
    render
  end

  def create
    if @level.save
      redirect_to [@game, @level]
    else      
      render :new
    end
  end

  def show
    render
  end

  def edit
    render
  end

  def update
    if @level.update(level_params)
      redirect_to [@level.game, @level]
    else
      render :edit
    end
  end

  def destroy
    @level.destroy
    redirect_to @game
  end

  def move_up
    @level.move_higher
    redirect_to @game
  end

  def move_down
    @level.move_lower
    redirect_to @game
  end

protected

  def level_params   
    params[:level].permit(:name, :text, :correct_answer) unless params[:level].nil?
  end
  
  def find_game
    @game = Game.find(params[:game_id])
  end

  def build_level
    @level = Level.new(level_params)    
    @level.game = @game
  end

  def find_level
    @level = Level.find(params[:id])
  end
end
