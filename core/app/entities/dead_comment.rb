DeadComment = StrictStruct.new(
  :id, :created_by, :created_at, :content, :type,
  :fact_data, :sub_comments_count, :created_by_id,
  :votes, :deletable?
) do

  def formatted_content
    FormattedCommentContent.new(content).html
  end

  def time_ago
    TimeFormatter.as_time_ago(created_at)
  end
end
