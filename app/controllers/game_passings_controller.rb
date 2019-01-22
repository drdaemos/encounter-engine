# -*- encoding : utf-8 -*-
class GamePassingsController < ApplicationController

  before_action :clear_play_as_var, :only => [:play_as_team]
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

  def play_as_team
    session[:play_as] = params[:team_id]
    redirect_to show_current_level_url(@game)
  end

  def show_current_level
    result = GamePassingInteractors::UpdateState.call(get_common_context)

    if @game_passing.finished?
      redirect_to game_finish_url(@game)
      clear_play_as_var
    else
      respond_to do |format|
        format.json { render json: result.app_state.to_json }
        format.html { render html: result.app_state.to_json.html_safe, :layout => 'in_game' }
      end
    end
  end

  def post_answer
    if @game_passing.finished?
      redirect_to game_finish_url(@game)
      clear_play_as_var
    else
      result = GamePassingInteractors::HandlePostAnswer.call(
          get_common_context.merge({:answer => params[:answer].strip})
      )

      if @game_passing.finished?
        redirect_to game_finish_url(@game)
        clear_play_as_var
      else
        render json: result.state_to_render.to_json
      end
    end
  end

  def exit_game
    @game_passing.exit!
    session[:play_as] = nil
    redirect_to game_finish_url(@game_passing.game)
  end

protected

  def clear_play_as_var
    session[:play_as] = nil
  end

  def get_common_context
    {
        :game_passing => @game_passing,
        :user => current_user
    }
  end

  def find_game
    @game = Game.find params[:game_id]
  end

  def find_game_by_id
    @game = Game.find params[:id]
  end

  def find_team
    if current_user.can_edit?(@game) && !session[:play_as].nil?
      @team = Team.friendly.find session[:play_as]
    end

    if @team.nil?
      @team = current_user.team
    end
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
