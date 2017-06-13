# -*- encoding : utf-8 -*-
class TeamRoomController < ApplicationController
  before_action :ensure_authenticated
  before_action :ensure_team_member

  def index
    @team = @_current_user.team
    render
  end
end
