# -*- encoding : utf-8 -*-
class IndexController < ApplicationController
  def index
    @games = Game.non_drafts
    render
  end
end
