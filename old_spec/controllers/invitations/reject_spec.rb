# -*- encoding : utf-8 -*-
require 'rails_helper'

describe Invitations, "#reject" do
  describe "when recepient attempts to reject the invitation" do
    before :each do
      @recepient = create_user
      @invitation = create_invitation :for => @recepient
    end

    it "redirects to dashboard"

    it "deletes the invitation" do
      perform_request :as_user => @recepient
      Invitation.exists?(@invitation.id).should be_false
    end
  end

  describe "when captain (sender) attempts to reject the invitation" do
    before :each do
      @captain = create_user
      team = create_team :captain => @captain
      @invitation = create_invitation :for => create_user, :from => team
    end

    it "raises Unauthorized" do
      assert_unauthorized { perform_request :as_user => @captain }
    end

    it "does not delete any invitation" do
      assert_does_not_delete_invitation { perform_rescued_request :as_user => @captain }
    end
  end

  describe "when other logged in user attempts to reject the invitation" do
    before :each do
      @some_user = create_user
      @invitation = create_invitation
    end

    it "raises Unauthorized" do
      assert_unauthorized { perform_request :as_user => @some_user }
    end

    it "does not delete any invitation" do
      assert_does_not_delete_invitation { perform_rescued_request :as_user => @some_user }
    end
  end

  describe "when guest attempts to reject the invitation" do
    before :each do
      @invitation = create_invitation
    end

    it "raises Unauthenticated" do
      assert_unauthenticated { perform_request }
    end
    
    it "does not delete any invitation" do
      assert_does_not_delete_invitation { perform_rescued_request }
    end
  end

  def assert_does_not_delete_invitation(&block)
    block.should_not change(Invitation, :count)
  end

  def perform_rescued_request(opts={})
    begin
      perform_request opts
    rescue
    end
  end

  def perform_request(opts={})
    params = { :id => @invitation.id }
    dispatch_to Invitations, :reject, params do |controller|
      controller.session.stub!(:authenticated?).and_return(opts.key?(:as_user))
      controller.session.stub!(:user).and_return(opts[:as_user])
    end
  end
end
