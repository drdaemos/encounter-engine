# -*- encoding : utf-8 -*-
class TeamRoomController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_team_member

  def index
    @team = current_user.team
    render
  end
end
