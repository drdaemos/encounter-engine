class DashboardController < ApplicationController
  before_filter :ensure_authenticated
  before_filter :find_invitations_for_current_user
  before_filter :find_team

  def index
=begin
    @games =Game.by(@current_user)
    @game_entries = []
    @teams = []
    @games.each do |game| # extract to models
      GameEntry.of_game(game).with_status("new").each do |entry|
         @game_entries << entry
      end
      GameEntry.of_game(game).with_status("accepted").each do |entry|
         @teams << entry.team
       end
    end
=end
  end

protected

  def find_invitations_for_current_user
    # @invitations = Invitation.for @current_user
    @invitations = []
  end

  def find_team
    @team = current_user.team if current_user.team
  end
end
