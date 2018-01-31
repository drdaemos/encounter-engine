# -*- encoding : utf-8 -*-
require 'rails_helper'

describe Exceptions, "#unauthenticated" do
  before(:each) do
    @response = dispatch_to(Exceptions, :unauthenticated, {})
  end

  it "responds successfully" do
    @response.should be_successful
  end
end
