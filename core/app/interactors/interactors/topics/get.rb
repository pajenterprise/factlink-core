module Interactors
  module Topics
    class Get
      include Pavlov::Interactor
      include Util::CanCan

      arguments :slug_title

      def execute
        topic
      end

      def topic
        @topic ||= query :'topics/get', slug_title
      end

      def validate
        validate_string :slug_title, slug_title
      end

      def authorized?
        return unless @options[:current_user]
        can? :show, topic
      end
    end
  end
end
