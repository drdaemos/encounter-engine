# -*- encoding : utf-8 -*-
class GamePassingsController < ApplicationController
  include GamePassingsHelper

  before_action :find_game, :except => [:exit_game]
  before_action :find_game_by_id, :only => [:exit_game]
  before_action :find_team, :except => [:show_results, :index]
  before_action :find_or_create_game_passing, :except => [:show_results, :index]
  before_action :authenticate_user!, :except => [:index, :show_results]
  before_action :ensure_game_is_started
  before_action :ensure_team_captain, :only => [:exit_game]
  before_action :ensure_not_finished, :except => [:index, :show_results]
  before_action :author_finished_at, :except => [:index, :show_results]
  before_action :ensure_team_member, :except => [:index, :show_results]
  before_action :ensure_not_author_of_the_game, :except => [:index, :show_results]
  before_action :ensure_author, :only => [:index]

  helper_method :app_data_helper

  def show_current_level
    if @game_passing.finished?
      render :show_results
    else 
      render :layout => 'in_game'
    end
  end

  def app_data_helper
    get_app_data(@team, @game).to_json.html_safe
  end

  def index
    @game_passings = GamePassing.of_game(@game)
    render
  end

  def get_current_level_tip
    get_current_level_tip_data(@game_passing).to_json
  end

  def post_answer
    unless @game_passing.finished?
     @answer = params[:answer].strip
      save_answer_to_log(@answer, @team, @game)
      @answer_was_correct = @game_passing.check_answer!(@answer)
      unless @game_passing.finished?
        render :show_current_level, :layout => 'in_game'
      else
        render :show_results
      end
    else
      render :show_results
    end
  end

  def show_results
    render
  end

  def exit_game
    @game_passing.exit!
    render :show_results
  end

protected

  def find_game
    @game = Game.find params[:game_id]
  end

  def find_game_by_id
    @game = Game.find(params[:id])
  end

  def find_team
    @team = current_user.team
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

  def ensure_game_is_started
    raise UnauthorizedError, "Нельзя играть в игру до её начала. И вообще, где вы достали эту ссылку? :-)" unless @game.started? unless @game.is_testing?
  end

  def ensure_not_author_of_the_game
    raise UnauthorizedError, "Нельзя играть в собственные игры, сорри :-)" if @game.created_by?(current_user) unless @game.is_testing?
  end

  def author_finished_at
    raise UnauthorizedError, "Игра была завершена автором, и вы не можете в нее больше играть" if @game.author_finished?
  end

  def ensure_captain_exited
    raise UnauthorizedError, "Команда сошла с дистанции" if @game_passing.exited?
  end

  def ensure_not_finished
    self.author_finished_at
    self.ensure_captain_exited
  end
end
