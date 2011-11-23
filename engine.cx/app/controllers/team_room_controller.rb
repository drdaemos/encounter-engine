class TeamRoomController < ApplicationController
  before_filter :ensure_authenticated
  before_filter :ensure_team_member

  def index
    @team = @current_user.team
  end
end
