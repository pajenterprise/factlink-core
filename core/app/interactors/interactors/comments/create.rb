require 'pavlov'

module Interactors
  module Comments
    class Create
      include Pavlov::Interactor

      arguments :fact_id, :type, :content

      def execute
        comment = command :create_comment, @fact_id, @type,
          @content, @options[:current_user].id.to_s

        command :'comments/set_opinion', comment.id.to_s, 'believes', @options[:current_user].graph_user
        command :'opinions/recalculate_comment_user_opinion', comment
        create_activity comment

        query :'comments/add_authority_and_opinion_and_can_destroy', comment, fact
      end

      def fact
        Fact[@fact_id]
      end

      def create_activity comment
        # TODO fix this ugly data access shit, need to think about where to kill objects, etc
        command :create_activity,
          @options[:current_user].graph_user, :created_comment,
          Comment.find(comment.id), comment.fact_data.fact
      end

      def authorized?
        @options[:current_user]
      end

      def validate
        validate_regex   :content, @content, /\S/,
          "should not be empty."
        validate_integer :fact_id, @fact_id
        validate_in_set  :type, @type, ['believes', 'disbelieves', 'doubts']
      end
    end
  end
end
