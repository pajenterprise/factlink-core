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
      stub_const('Comment',Class.new)
      stub_const('Fact',Class.new)
    end

    it 'correctly' do
      fact = mock(id: 3)
      opinion = 'believes'
      query = Queries::GetComments.new fact.id, opinion
      comment = mock(content: 'bla', id: 1, opinion: opinion, fact_data: stub())
      fact_data_id = '3b'

      Fact.should_receive(:[]).with(fact.id).and_return(stub(data_id: fact_data_id))
      Comment.should_receive(:where).
        with(fact_data_id: fact_data_id, opinion: opinion).
        and_return([comment])

      results = query.execute

      results.should eq [comment]

    end
  end
end
