require 'spec_helper'

describe FactsController do

  # TODO factor out, because each controller needs this
  def authenticate_user!
    @user = FactoryGirl.create(:user)
    request.env['warden'] = mock(Warden, :authenticate => @user, :authenticate! => @user)
  end

  def create_fact_relation
    @fact     = FactoryGirl.create(:fact)
    @evidence = FactoryGirl.create(:fact)
    @fr       = FactoryGirl.create(:fact_relation)
    # Set the relation
    @fr.from_fact = @fact
    @fr.fact = @evidence
  end

  describe :store_fact_for_non_signed_in_user do
    it "should work"
  end

  describe :show do
    it "should render succesful" do
      @fact = FactoryGirl.create(:fact)
      get :show, :id => @fact.id
      response.should be_succes
    end
    it "should return a list of @potential_evidence"
    it "should not include itself in @potential_evidence"
    it "should not include facts in potential evidence which already both support and weaken"
  end

  describe :new do
    it "should return a new Fact object" do
      authenticate_user!
      get :new
      assigns[:fact].should be_a_new(Fact)
    end
  end

  describe :edit do
    it "should edit the given fact" do
      authenticate_user!
      
      @fact = FactoryGirl.create(:fact)
      get :edit, :id => @fact.id
      
      assigns[:fact].should == @fact
    end  
  end

  describe :prepare do
    it "should render the correct template" do
      get :prepare
      response.should render_template("prepare")
    end
  end

  describe :intermediate do
    it "should have the correct assignments" do
      
      url     = "http://en.wikipedia.org/wiki/Batman"
      passage = "NotImplemented"
      fact    = "Batman is a fictional character"     # Actually the displaystring
      
      post :intermediate, :url      => url, 
                          :passage  => passage, 
                          :fact     => fact,
                          :the_action => "prepare"
      
      response.code.should eq("200")
      
      # Url is not working, really weird?
      # assigns[:url].should == url

      assigns(:passage).should == passage
      assigns(:fact).should == fact
            
    end

   
  end

  describe :create do
    it "should work" do
      pending
      authenticate_user!
      post 'create'
      response.should redirect_to(factlink_path)
    end
  end

  describe :add_supporting_evidence do
    it "should respond to XHR" do
      authenticate_user!
      xhr :get, :add_supporting_evidence,
        :fact_id => FactoryGirl.create(:fact).id,
        :evidence_id => FactoryGirl.create(:fact).id

      response.code.should eq("200")
    end
    
  end

  describe :add_weakening_evidence do
    it "should respond to XHR" do
      authenticate_user!
      xhr :get, :add_supporting_evidence,
        :fact_id => FactoryGirl.create(:fact).id,
        :evidence_id => FactoryGirl.create(:fact).id

      response.code.should eq("200")
    end
  end

  describe :remove_factlink_from_parent do    
    it "should work"
  end

  describe :update do
    it "should work"
  end

  describe :toggle_opinion_on_fact do
    it "should not respond to non-allowed types" do
      authenticate_user!
      create_fact_relation

      get "toggle_opinion_on_fact", { :fact_relation_id => @fr.id, :type => "baron_is_not_allowed" }
      parsed_content = JSON.parse(response.body)
      parsed_content.should have_key("error")
      parsed_content['error'].should == "type not allowed"
    end

    it "should respond to allowed types" do
      authenticate_user!
      create_fact_relation

      # Check for all available types
      [:beliefs, :doubts, :disbeliefs].each do |type|
        xhr :get, "toggle_opinion_on_fact", { :fact_relation_id => @fr.id, :type => type }
        response.code.should eq("200")
      end
    end

  end

  describe :toggle_relevance_on_fact_relation do
    it "should not respond to non-allowed types" do
      authenticate_user!
      create_fact_relation

      get "toggle_relevance_on_fact_relation", { :fact_relation_id => @fr.id, :type => "baron_is_not_allowed" }
      parsed_content = JSON.parse(response.body)
      parsed_content.should have_key("error")
      parsed_content['error'].should == "type not allowed"
    end
    
    it "should respond to allowed types" do
      authenticate_user!
      create_fact_relation

      # Check for all available types
      [:beliefs, :doubts, :disbeliefs].each do |type|
        xhr :get, "toggle_opinion_on_fact", { :fact_relation_id => @fr.id, :type => type }
        response.code.should eq("200")
      end
    end
    
    it "should have the FactRelation assigned" do
      authenticate_user!
      create_fact_relation

      xhr :get, "toggle_relevance_on_fact_relation", { :fact_relation_id => @fr.id, :type => "beliefs" }
      assigns[:fact_relation].should == @fr
    end
  end

  # Currently not used
  describe :interaction_users_for_factlink do
    it "should have the correct assigns" do
      pending 
      @fact = FactoryGirl.create(:fact)
      
      get :interaction_users_for_factlink, :factlink_id => @fact.id
      
      assigns[:fact].should == @fact
      
      assigns[:believers].all.should =~ []
      assigns[:doubters].all.should =~ []
      assigns[:disbelievers].all.should =~ []
    end
  end

  describe :search do
    it "should return relevant results when a search parameter is given" do      
      result_set = (
        [FactData.new(:displaystring => 10), FactData.new(:displaystring => 12), FactData.new(:displaystring => 13)]
      )
      
      sunspot_search = mock(Sunspot::Search::StandardSearch)
      sunspot_search.stub!(:results).and_return { result_set }
      
      FactData.should_receive(:search).and_return(sunspot_search)
      
      post "search", :s => "1"
      assigns(:factlinks).should == result_set
    end
    
    it "should return all results when no search parameter is given" do
      result_set = (
        [FactData.new(:displaystring => 10), FactData.new(:displaystring => 12), FactData.new(:displaystring => 13)]
      )
      
      mock_criteria = mock(Mongoid::Criteria)

      mock_criteria.stub!(:skip).and_return { mock_criteria }
      mock_criteria.stub!(:limit).and_return { mock_criteria }

      mock_criteria.stub!(:to_a).and_return { result_set }
      
      FactData.should_receive(:all).and_return(mock_criteria)
      
      post "search"
      assigns(:factlinks).should == result_set
    end
  end

  describe :indication do
    it "should respond to XHR request" do
      xhr :get, :indication
      response.should be_succes
    end
  end


end
