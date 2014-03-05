require 'spec_helper'
require "cancan/matchers"

describe Ability do

  # abilities
  subject                { Ability.new(user) }
  let(:anonymous)        { Ability.new }
  let(:admin)            { Ability.new admin_user }

  # users used as object
  let(:user)        { create :user }
  let(:other_user)  { create :user }
  let(:admin_user)  { create :user, :admin }

  let(:deleted_user) { create :user, deleted: true }

  describe "to manage a user" do
    context "as a normal user" do
      it { subject.should_not be_able_to :manage, User }
      it { subject.should_not be_able_to :configure, Ability::FactlinkWebapp }

      it { subject.should     be_able_to :show, user }
      it { subject.should     be_able_to :show, other_user }
      it { subject.should     be_able_to :update, user }
      it { subject.should     be_able_to :destroy, user }

      it { subject.should     be_able_to :edit_settings, user }
      it { subject.should     be_able_to :set_up, user }

      it { subject.should_not be_able_to :update, other_user }
      it { subject.should_not be_able_to :update, admin }
      it { subject.should_not be_able_to :destroy, other_user }

      it { subject.should be_able_to :show, deleted_user }
    end
    context "as an admin" do
      it { admin.should     be_able_to :manage, User }
      it { admin.should     be_able_to :configure, Ability::FactlinkWebapp }

      it { admin.should_not be_able_to :edit_settings, user }
      it { admin.should be_able_to     :edit_settings, admin_user }

      it { admin.should     be_able_to :set_up, user }
      it { admin.should     be_able_to :set_up, admin_user }
    end
    context "as an anonymous" do
      it { anonymous.should_not be_able_to :manage, User }

      it { anonymous.should_not be_able_to :set_up, user }
      it { anonymous.should     be_able_to :show, User }
      it { anonymous.should_not be_able_to :edit_settings, user }
    end
  end

  describe "to get the fact count of a site" do
    context "as any user" do
      it { subject.should   be_able_to :get_fact_count, Site }
      it { anonymous.should be_able_to :get_fact_count, Site }
    end
  end

  describe "to manage facts" do
    let(:fact) { create :fact }

    it { subject.should be_able_to :index, Fact }
    it { subject.should be_able_to :create, Fact }

    describe "of someone else" do
      it { subject.should_not  be_able_to :update, fact }
      it { subject.should      be_able_to :read, fact }
      it { subject.should      be_able_to :opinionate, fact }
      it { subject.should      be_able_to :share, fact }
    end

    describe "without logging in" do
      it { anonymous.should      be_able_to :index, Fact }
      it { anonymous.should      be_able_to :read, fact }
      it { anonymous.should      be_able_to :create, Fact }

      it { anonymous.should_not  be_able_to :update, fact }
      it { anonymous.should_not  be_able_to :opinionate, Fact }
      it { anonymous.should_not  be_able_to :add_evidence, fact }
      it { anonymous.should_not  be_able_to :share, fact }
    end
  end

  describe "to manage Comments" do
    let(:c1) { create :comment, created_by: user }
    let(:c2) { create :comment, created_by: other_user }

    describe "of my own" do
      it { subject.should be_able_to :read, c1 }
      it { subject.should be_able_to :destroy, c1 }
    end

    describe "of someone else" do
      it { subject.should     be_able_to :read, c2 }
      it { subject.should_not be_able_to :destroy, c2 }
    end

    describe "without logging in" do
      it { anonymous.should     be_able_to :read, c1 }
      it { anonymous.should_not be_able_to :destroy, c1 }
    end
  end

  describe "accessing the admin area" do
    it "should only be allowed as admin" do
      admin.should         be_able_to :access, Ability::AdminArea
      subject.should_not   be_able_to :access, Ability::AdminArea
      anonymous.should_not be_able_to :access, Ability::AdminArea
    end
  end

  describe "accessing factlink" do
    it "should be allowed to signed in, set up users" do
      admin.should           be_able_to :access, Ability::FactlinkWebapp
      subject.should         be_able_to :access, Ability::FactlinkWebapp
      anonymous.should_not   be_able_to :access, Ability::FactlinkWebapp
    end
  end

  describe "sharing" do
    it "should not be allowed by default" do
      admin.should_not     be_able_to :share_to, admin_user.social_account('twitter')
      subject.should_not   be_able_to :share_to, user.social_account('twitter')
      admin.should_not     be_able_to :share_to, admin_user.social_account('facebook')
      subject.should_not   be_able_to :share_to, user.social_account('facebook')
    end

    context "when connected to Twitter" do
      it "should be possible to share to Twitter" do
        create :social_account, :twitter, user: user

        Ability.new(user).should be_able_to :share_to, user.social_account('twitter')
      end
    end

    context "when connected to Facebook" do
      it "should be possible to share to Facebook" do
        create :social_account, :facebook, user: user

        Ability.new(user).should be_able_to :share_to, user.social_account('facebook')
      end
    end
  end

end
