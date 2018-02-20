# -*- encoding : utf-8 -*-
class GamePassingsController < ApplicationController
  include GamePassingsHelper

  before_action :find_game, :except => [:exit_game]
  before_action :find_game_by_id, :only => [:exit_game]
  before_action :find_team
  before_action :find_or_create_game_passing
  before_action :authenticate_user!
  before_action :ensure_game_is_started, :except => [:show_current_level]
  before_action :ensure_team_captain, :only => [:exit_game]
  before_action :ensure_not_finished
  before_action :ensure_current_level_is_active
  before_action :author_finished_at
  before_action :ensure_team_member
  before_action :ensure_not_author_of_the_game

  helper_method :app_data_helper

  def show_current_level
    if @game_passing.finished?
      redirect_to game_stats_url(@game)
    else 
      render html: '', :layout => 'in_game'
    end
  end

  def app_data_helper
    get_app_data(@team, @game).to_json.html_safe
  end

  def get_current_level_tip
    get_current_level_tip_data(@game_passing).to_json
  end

  def post_answer
    if @game_passing.finished?
      redirect_to game_stats_url(@game)
    else
      @answer = params[:answer].strip
      save_answer_to_log(@answer, @team, @game)
      @answer_was_correct = @game_passing.check_answer!(@answer)

      if @game_passing.finished?
        redirect_to game_stats_url(@game)
      else
        render :show_current_level, :layout => 'in_game'
      end
    end
  end

  def exit_game
    @game_passing.exit!
    redirect_to game_stats_url(@game_passing.game)
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
        :game => @game

      if @game.started?
        @game_passing.current_level = @game.levels.first
      end
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

  def ensure_current_level_is_active
    fail_level_if_limit_is_passed(@game_passing)
  end
end
