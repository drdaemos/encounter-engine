# -*- encoding : utf-8 -*-
class GameEntriesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_game, :only=>:new
  before_action :find_team, :only=>:new
  before_action :find_entry, :except =>:new
  before_action :ensure_author, :only => [:accept, :reject]
  before_action :ensure_team_captain, :except => [:accept, :reject]

  def new
    if @game.can_request?
      @game_entry = GameEntry.create! :status => 'new', :game => @game, :team => @team
      @game.reserve_place_for_team!
    end
    redirect_to :dashboard
  end

  def reopen
    if @game.can_request?
      if @entry.status != "accepted"
        @entry.reopen!
      end
      @game.reserve_place_for_team!
    end
    redirect_to :dashboard
  end
  
  def accept
    if @entry.status == "new"
       @entry.accept!
    end
    # redirect_to :dashboard
  end
  
  def reject
    if @entry.status == "new"
       @entry.reject!
    end
    @game.free_place_of_team!
    # redirect_to :dashboard
  end

  def recall
    if @entry.status == "new"
       @entry.recall!
    end
    @game.free_place_of_team!
    redirect_to :dashboard
  end

  def cancel
    if @entry.status == "accepted"
      @entry.cancel!
    end
    @game.free_place_of_team!
    redirect_to :dashboard
  end

protected
  def find_game
    @game = Game.find(params[:game_id])
  end
  
  def find_team
    @team = Team.find(params[:team_id])
  end

  def find_entry
    @entry = GameEntry.find(params[:id])
    if @entry
      @game = Game.find(@entry.game.id)
    end
  end

end
