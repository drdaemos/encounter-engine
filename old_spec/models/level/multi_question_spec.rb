# -*- encoding : utf-8 -*-
require 'rails_helper'

describe Level, "multi_question?" do
  before :each do
    @level = create_level
  end

  subject { @level.multi_question?  }

  context "when there is one question" do    
    it { should be_false }
  end

  context "when there are more than one question" do
    before :each do
      create_question :level => @level
    end

    it { should be_true }
  end
end
