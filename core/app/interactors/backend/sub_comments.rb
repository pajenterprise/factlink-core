module Backend
  module SubComments
    def self.count(parent_id:)
      SubComment.where(parent_id: parent_id.to_s).count
    end

    def self.index(parent_ids_in:)
      parent_ids = Array(parent_ids_in)
      sub_comments = SubComment.any_in(parent_id: parent_ids).asc(:created_at)
      sub_comments.map do |sub_comment|
        KillObject.sub_comment sub_comment
      end
    end

    def self.destroy!(id:)
      SubComment.find(id).delete
    end

    def self.create!(parent_id:, content:, user:)
      sub_comment = SubComment.new
      sub_comment.parent_id = parent_id.to_s
      sub_comment.created_by = user
      sub_comment.content = content
      sub_comment.save!

      sub_comment
    end
  end
end