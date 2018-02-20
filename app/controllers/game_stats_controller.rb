class GameStatsController < ApplicationController
  before_action :find_game, :except => [:index]
  before_action :find_game_passings, :except => [:index]
  before_action :ensure_team_member, :only => [:finish]
  before_action :ensure_author, :only => [:publish, :takedown]

  def index
    @games = Game.results_available_for(current_user)

    render
  end

  def show

    render
  end

  def finish

    render
  end

  def publish
    redirect_back :fallback_location => game_stats_path(@game)
  end

  def takedown
    redirect_back :fallback_location => game_stats_path(@game)
  end

  private

  def find_game
    @game = Game.find params[:game_id]
  end

  def find_game_by_id
    @game = Game.find(params[:id])
  end

  def find_team
    @team = current_user.team
  end

  def find_game_passing
    @game_passing = GamePassing.of(@team, @game)
  end

  def find_game_passings
    @game_passings = GamePassing.of_game(@game)
  end
end
