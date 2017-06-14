# -*- encoding : utf-8 -*-
require File.join( File.dirname(__FILE__), 'rails_rspec' ) 
require "autotest/cucumber_mixin"
class Autotest::CucumberRailsRspec < Autotest::RailsRspec
  include CucumberMixin
  def cucumber
    `which cucumber`.chomp
  end
end
