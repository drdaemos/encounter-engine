# -*- encoding : utf-8 -*-
class IndexController < ApplicationController
  def index
    @games = Game.available_previews
    render
  end
end
