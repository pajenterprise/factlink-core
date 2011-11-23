require 'spec_helper'

describe FactsController do
  include Devise::TestHelpers
  include ControllerMethods
  render_views

  let(:user) { FactoryGirl.create(:user) }

  describe :show do
    it "should render succesful" do
      @fact = FactoryGirl.create(:fact)
      get :show, :id => @fact.id
      response.should be_succes
    end
    
    it "should escape html in fields" do
      @site = FactoryGirl.create(:site)
      
      @fact = Fact.create(
        :created_by => user.graph_user,
        :site => @site
      )
      @fact.data.displaystring = "baas<xss> of niet"
      @fact.data.title = "baas<xss> of niet"
      @fact.data.save
      
      get :show, :id => @fact.id
      
      response.body.should_not match(/<xss>/)
    end
  end

  describe :intermediate do
    it "should have the correct assignments" do
      post :intermediate, :the_action => "prepare"
      response.code.should eq("200")
    end
  end

  describe :create do
    it "should work" do
      authenticate_user!(user)
      post 'create', :url => "http://example.org/",  :displaystring => "Facity Fact", :title => "Title"
      response.should redirect_to(created_fact_path(Fact.all.to_a.last.id))
    end
    
    it "should work with json" do
      authenticate_user!(user)
      post 'create', :format => :json, :url => "http://example.org/",  :displaystring => "Facity Fact", :title => "Title"
      response.code.should eq("201")
    end
  end

  describe :add_supporting_evidence do
    it "should respond to XHR" do
      authenticate_user!(user)
      xhr :get, :add_supporting_evidence,
        :id => FactoryGirl.create(:fact).id,
        :evidence_id => FactoryGirl.create(:fact).id

      response.code.should eq("200")
    end
    
  end

  describe :add_weakening_evidence do
    it "should respond to XHR" do
      authenticate_user!(user)
      xhr :get, :add_supporting_evidence,
        :id => FactoryGirl.create(:fact).id,
        :evidence_id => FactoryGirl.create(:fact).id

      response.code.should eq("200")
    end
  end




end
