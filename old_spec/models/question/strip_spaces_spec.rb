# -*- encoding : utf-8 -*-
require 'rails_helper'

describe Question, "#strip_spaces" do
  describe "when correct_answers contains leading or trailing spaces" do
    subject { Question.new :answer => "   bla bla   " }

    describe "when saved" do
      before :each do
        subject.save!
      end

      it "should strip redundant spaces" do
        subject.answer.should == "bla bla"
      end
    end
  end
end
