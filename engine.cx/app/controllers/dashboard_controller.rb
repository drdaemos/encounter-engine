class DashboardController < ApplicationController
=begin
     ensure_authenticated!
    @games = Game.by(@current_user)
    @game_entries = []
    @teams = []
    @team = @current_user.team
    @invitations = Invitation.for @current_user
    @games.each do |game|
      GameEntry.of_game(game).with_status("new").each do |entry|
         @game_entries << entry
      end
      GameEntry.of_game(game).with_status("accepted").each do |entry|
         @teams << entry.team
       end
    end
    render
=end

  def index
    
  end
end
