module Queries
  module Opinions
    class InteractingUsersImpactForFact
      include Pavlov::Query

      arguments :fact_id, :type

      def execute
        OpinionPresenter.new(Opinion::BaseFactCalculation.new(fact).get_user_opinion).authority(type)
      end

      def fact
        Fact[fact_id]
      end
    end
  end
end
