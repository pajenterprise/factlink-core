module Interactors
  module Channels
    class Follow
      include Pavlov::Interactor

      arguments :channel_id

      def execute
        # raise 'not found' unless channel and subchannel
        command :'channels/add_subchannel', channel, prospective_follower
      end

      def channel
        @channel ||= Channel[channel_id]
      end

      def prospective_follower
        query_result = query :'channels/get_by_slug_title', channel.slug_title
        if query_result.nil?
          command :'channels/create', channel.title
        else
          query_result
        end
      end

      def authorized?
        true
      end

    end
  end
end
