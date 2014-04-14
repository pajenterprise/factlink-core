module Interactors
  module Users
    class Following
      include Pavlov::Interactor

      arguments :username

      def authorized?
        true
      end

      def validate
        validate_nonempty_string :username, username
      end

      def execute
        Backend::Users.by_ids(user_ids: graph_user_ids, by: :graph_user_id)
      end

      def graph_user_ids
        @graph_user_ids ||= begin
          user = Backend::Users.user_by_username(username: username)

          Backend::UserFollowers.followee_ids(follower_id: user.graph_user_id.to_s)
        end
      end
    end
  end
end
