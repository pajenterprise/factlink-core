require 'spec_helper'

describe FactRelation do

  let(:gu) {FactoryGirl.create :graph_user}
  let(:gu2) {FactoryGirl.create :graph_user}

  before(:each) do
    @evidence = FactoryGirl.create_list(:fact,2)
    @users = FactoryGirl.create_list(:user,2)
  end


  describe "#get_or_create" do
    it "should return a new factrelation when the relation does not exist" do
      @fact1 =FactoryGirl.create(:fact)
      @fact2 =FactoryGirl.create(:fact)
      @fr = FactRelation.get_or_create(@fact1, :supporting, @fact2, gu)
      @fr.should be_a(FactRelation)
      @fr.should_not be_new
    end


    [:supporting, :weakening, 'supporting','weakening'].each do |type|
      it "should return a new factrelation when the relation does not exist" do
        @fact1 =FactoryGirl.create(:fact)
        @fact2 =FactoryGirl.create(:fact)
        @fr = FactRelation.new type: type,
                               fact: @fact1,
                               from_fact: @fact2
        @fr.save
        @fr.should_not be_new
      end
    end

    it "should return a new factrelation when the relation does not exist" do
      @fact1 =FactoryGirl.create(:fact)
      @fact2 =FactoryGirl.create(:fact)
      @fr = FactRelation.new type: :retroverting,
                             fact: @fact1,
                             from_fact: @fact2
      @fr.save
      @fr.should be_new
    end

    it "should have a created_by GraphUser when created" do
      @parent = FactoryGirl.create(:fact)
      @fr = FactRelation.get_or_create(@evidence[0], :supporting, @parent, gu)
      @fr.created_by.should be_a(GraphUser)
    end

    it "should find the relation when the relation does exist" do
      @fact1 =FactoryGirl.create(:fact)
      @fact2 =FactoryGirl.create(:fact)
      @fr = FactRelation.get_or_create(@fact1,:supporting,@fact2,gu)
      @fr.should be_a(FactRelation)
      @fr2 = FactRelation.get_or_create(@fact1,:supporting,@fact2,gu)
      @fr2.should be_a(FactRelation)
      @fr3 = FactRelation.get_or_create(@fact1,:supporting,@fact2,gu)
      @fr3.should be_a(FactRelation)
      @fr.should == @fr2
      @fr2.should == @fr3
    end
  end

  it "should add itself to the list of evidence" do
    @fact1 =FactoryGirl.create(:fact)
    @fact2 =FactoryGirl.create(:fact)
    @fr = FactRelation.get_or_create(@fact1,:supporting,@fact2,gu)
    @fact2.evidence(:supporting).to_a.collect{ |x| x.from_fact }.should =~ [@fact1]
  end

  it "should delete itself from lists referring to it" do
    @fact1 =FactoryGirl.create(:fact)
    @fact2 =FactoryGirl.create(:fact)
    @fr = FactRelation.get_or_create(@fact1,:supporting,@fact2,gu)
    @fact1.delete
    @fact2.evidence(:supporting).size.should == 0
  end
  
  it "should not be able to create identical factRelations" do
    @fact1 = FactoryGirl.create(:fact)
    @fact2 = FactoryGirl.create(:fact)
    @fr1 = FactRelation.get_or_create(@fact1,:supporting,@fact2,gu)
    @fr2 = FactRelation.get_or_create(@fact1,:supporting,@fact2,gu)
    FactRelation.all.size.should == 1
    @fr3 = FactRelation.create_new(@fact2,:supporting,@fact1,gu)
    @fr4 = FactRelation.create_new(@fact2,:supporting,@fact1,gu)
    FactRelation.all.size.should == 2  
  end

  describe :deletable? do
    before do
      @fact1 = FactoryGirl.create(:fact)
      @fact2 = FactoryGirl.create(:fact)
      @fr = FactRelation.get_or_create(@fact1,:supporting,@fact2,gu)
    end
    it "should be true initially" do
      @fr.deletable?.should be_true
    end
    it "should be true if only the creator believes it" do
      @fr.add_opiniated(:believes, gu)
      @fr.deletable?.should be_true
    end
    it "should be false after someone else believes the relation" do
      @fr.add_opiniated(:believes, gu2)
      @fr.deletable?.should be_false
    end
    it "should be true if only the creator believes it" do
      @fr.add_opiniated(:disbelieves, gu2)
      @fr.deletable?.should be_true
    end
    it "should be true if only the creator believes it" do
      @fr.add_opiniated(:doubts, gu2)
      @fr.deletable?.should be_true
    end
  end

end