require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/facts/get_dead_wheel.rb'
require_relative '../../../../app/entities/dead_fact_wheel.rb'

describe Queries::Facts::GetDeadWheel do
  include PavlovSupport

  describe '.validate' do
    it 'requires fact_id to be an integer' do
      expect_validating('a', :id).
        to fail_validation('id should be an integer string.')
    end
  end

  describe '.execute' do
    before do
      stub_const('Fact',Class.new)
    end

    it 'returns a fact_wheel representation' do
      opinion = mock :opinion, as_percentages: {
        authority: 14
      }
      live_fact = mock :fact, id: '1', get_opinion: opinion
      interactor = Queries::Facts::GetDeadWheel.new live_fact.id

      Fact.stub(:[]).with(live_fact.id).and_return(live_fact)

      dead_fact_wheel = interactor.execute

      expect(dead_fact_wheel.authority).to eq live_fact.get_opinion.as_percentages[:authority]
    end

  end
end
