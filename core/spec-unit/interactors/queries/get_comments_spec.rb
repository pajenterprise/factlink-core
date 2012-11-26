require 'pavlov_helper'
require_relative '../../../app/interactors/queries/get_comments.rb'

describe Queries::GetComments do
  include PavlovSupport

  it 'initializes correctly' do
    query = Queries::GetComments.new 1, 'believes'

    query.should_not be_nil
  end

  it 'with an invalid fact_id should raise a validation error' do
    expect { Queries::GetComments.new 'a', 'believes'}.
      to raise_error(Pavlov::ValidationError, 'fact_id should be an integer.')
  end

  it 'with an invalid opinion should raise a validation error' do
    expect { Queries::GetComments.new 1, 'mwah'}.
      to raise_error(Pavlov::ValidationError, 'opinion should be on of these values: ["believes", "disbelieves", "doubts"].')
  end

  describe '.execute' do
    before do
      stub_classes('Comment','Fact')
    end

    it 'correctly' do
      fact = mock(id: 3)
      opinion = 'believes'
      user = mock()
      query = Queries::GetComments.new fact.id, opinion, current_user: user
      content = 'bla'
      comment_id = '1a'
      comment = mock(created_by: user, content: content, id: comment_id, opinion: opinion, fact_data: mock(fact: fact))
      fact_data_id = '3b'
      authority = mock
      authority_string = '1.0'

      Fact.should_receive(:[]).with(fact.id).and_return(stub(data_id: fact_data_id))
      Comment.should_receive(:where).
        with(fact_data_id: fact_data_id, opinion: opinion).
        and_return([comment])
      Authority.should_receive(:on).with(fact, for: user).and_return(authority)
      authority.should_receive(:to_s).with(1.0).and_return(authority_string)
      comment.should_receive(:authority=).with(authority_string)

      results = query.execute

      results.first.opinion.should eq opinion
      results.first.content.should eq content
      results.first.id.should eq comment_id
    end
  end
end
