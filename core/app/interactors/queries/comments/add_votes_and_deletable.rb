module Queries
  module Comments
    class AddVotesAndDeletable
      include Pavlov::Query

      arguments :comment

      def execute
        DeadComment.new(
          id: comment.id,
          created_by: query(:users_by_ids, user_ids: comment.created_by_id).first,
          created_at: comment.created_at,
          content: comment.content,
          type: comment.type,
          fact_data: comment.fact_data,
          created_by_id: comment.created_by_id,
          sub_comments_count: comment.sub_comments_count,
          votes: votes,
          deletable?: deletable?,
        )
      end

      def votes
        query(:'believable/votes', believable: believable)
      end

      def believable
        @believable ||= ::Believable::Commentje.new comment.id
      end

      def deletable?
        query(:'comments/is_deletable', comment_id: comment.id.to_s)
      end
    end
  end
end
