# -*- encoding : utf-8 -*-
class GamePassingsController < ApplicationController

  before_action :find_game, :except => [:exit_game]
  before_action :find_game_by_id, :only => [:exit_game]
  before_action :find_team
  before_action :find_or_create_game_passing
  before_action :authenticate_user!
  before_action :ensure_game_is_started, :except => [:show_current_level]
  before_action :ensure_team_captain, :only => [:exit_game]
  before_action :ensure_not_finished, :except => [:show_current_level]
  before_action :ensure_team_member
  before_action :ensure_not_author_of_the_game

  helper_method :app_data_helper

  def show_current_level
    GamePassingInteractors::CheckCurrentState.call(
        {
            :game_passing => @game_passing,
            :user => current_user
        }
    )

    if @game_passing.finished?
      redirect_to game_finish_url(@game)
    else 
      render html: '', :layout => 'in_game'
    end
  end

  def app_data_helper
    result = GamePassingInteractors::UpdateState.call(
        {
            :game_passing => @game_passing,
            :user => current_user
        }
    )

    result.app_state.to_json.html_safe if result.success?
  end

  def post_answer
    if @game_passing.finished?
      redirect_to game_finish_url(@game)
    else
      result = GamePassingInteractors::PostAnswer.call(
        {
          :game_passing => @game_passing,
          :user => current_user,
          :answer => params[:answer].strip
        }
      )

      if @game_passing.finished?
        redirect_to game_finish_url(@game)
      else
        redirect_to show_current_level_url(@game)
      end
    end
  end

  def exit_game
    @game_passing.exit!
    redirect_to game_finish_url(@game_passing.game)
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
      result = GamePassingInteractors::CreatePassing.call :team => @team,
                                  :game => @game

      @game_passing = result.game_passing if result.success?
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
