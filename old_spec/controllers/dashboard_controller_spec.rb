# -*- encoding : utf-8 -*-
require 'rails_helper'

RSpec.describe DashboardController, :type => :controller do
  describe "GET index" do
    it "assigns @games" do
      games = Game.all
      get :index
      expect(assigns(:games)).to eq([games])
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end
end
