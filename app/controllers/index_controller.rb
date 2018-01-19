# -*- encoding : utf-8 -*-
class IndexController < ApplicationController
  def index
    @games = Game.available_for(current_user)
    render
  end
end
