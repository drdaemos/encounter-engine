# -*- encoding : utf-8 -*-
class DashboardController < ApplicationController
  before_action :ensure_authenticated
  before_action :find_invitations_for_current_user
  before_action :find_team

  def index
    @games =Game.by(@_current_user)
    @game_entries = []
    @teams = []
    @games.each do |game|
      GameEntry.of_game(game).with_status("new").each do |entry|
         @game_entries << entry
      end
      GameEntry.of_game(game).with_status("accepted").each do |entry|
         @teams << entry.team
       end
    end
    render
  end

protected

  def find_invitations_for_current_user
    @invitations = Invitation.for @_current_user
  end

  def find_team
    @team = @_current_user.team if @_current_user.team
  end
end
