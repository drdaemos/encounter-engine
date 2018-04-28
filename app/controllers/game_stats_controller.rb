class GameStatsController < ApplicationController
  before_action :find_game, :except => [:index, :remove_adjustment]
  before_action :find_team, :only => [:adjustments, :add_adjustment]
  before_action :find_game_passing, :only => [:adjustments, :add_adjustment]
  before_action :find_adjustment, :only => [:remove_adjustment]
  before_action :find_game_passings, :except => [:index]
  before_action :build_adjustment, :only => [:adjustments, :add_adjustment]
  before_action :ensure_team_member, :only => [:finish]
  before_action :ensure_author, :only => [:publish, :takedown]
  before_action :ensure_author_if_not_published, :only => [:show]

  def index
    @games = Game.results_available_for(current_user)
    render
  end

  def show
    render
  end

  def add_adjustment
    @adjustment.save
    redirect_back :fallback_location => game_stats_adjustments_path(@game, @team)
  end

  def remove_adjustment
    @game = @adjustment.game_passing.game
    @team = @adjustment.game_passing.team
    @adjustment.destroy
    redirect_back :fallback_location => game_stats_adjustments_path(@game, @team)
  end

  def adjustments
    render
  end

  def finish
    render
  end

  def publish
    GameInteractors::Publish.call({:game => @game, :user => current_user})
    redirect_back :fallback_location => game_stats_path(@game)
  end

  def takedown
    GameInteractors::Takedown.call({:game => @game, :user => current_user})
    redirect_back :fallback_location => game_stats_path(@game)
  end

  protected

  def render_sidebar?
    action_name === 'index' || action_name === 'finish'
  end

  private

  def adjustment_params
    if params[:adjustment].nil?
      return nil
    end

    params[:adjustment][:adjustment] = params[:adjustment][:adjustment].to_i.abs

    if params[:adjustment][:type] == "penalty"
      params[:adjustment][:adjustment] = params[:adjustment][:adjustment] * -1
    end

    params[:adjustment].permit(:adjustment, :reason)
  end

  def build_adjustment
    @adjustment = PassingAdjustment.new(adjustment_params)
    @adjustment.game_passing = @game_passing
    @adjustment
  end

  def find_game
    @game = Game.find params[:game_id]
  end

  def find_team
    @team = Team.friendly.find params[:team_id]
  end

  def find_game_by_id
    @game = Game.find params[:id]
  end

  def find_adjustment
    @adjustment = PassingAdjustment.find params[:adjustment_id]
  end

  def find_game_passing
    @game_passing = GamePassing.of(@team, @game)
  end

  def find_game_passings
    @game_passings = GamePassing.of_game(@game)
  end

  def ensure_author_if_not_published
    unless @game.published?
      ensure_author
    end
  end
end
