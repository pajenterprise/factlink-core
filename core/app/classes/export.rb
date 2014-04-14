class Export
  def export
    output = ''

    User.all.order_by(username: 1).each do |user|
      output << import('FactlinkImport.user', fields_from_object(user, User.import_export_simple_fields + [
        :encrypted_password, :confirmed_at, :confirmation_token, :confirmation_sent_at
      ])) + "\n"

      user.social_accounts.each do |social_account|
        output << import('FactlinkImport.social_account',
          fields_from_object(social_account, SocialAccount.import_export_simple_fields).merge(
            username: user.username)
        ) + "\n"
      end
    end

    FactData.all.order_by(fact_id: 1).each do |fact_data|
      output << import('FactlinkImport.fact', fields_from_object(fact_data, [
        :fact_id, :displaystring, :title, :url, :created_at
      ])) + " do\n"

      sorted_votes = Backend::Facts.votes(fact_id: fact_data.fact_id).sort do |a, b|
        a[:username] <=> b[:username]
      end

      sorted_votes.each do |vote|
        output << '  '
        output << import('interesting', username: vote[:user].username)
        output << "\n"
      end

      output << "end\n"
    end

    comment_array = Comment.all.to_a
    comment_array.sort do |c1, c2|
      created_at_ordering = c1.created_at.utc.to_s <=> c2.created_at.utc.to_s
      if created_at_ordering == 0
        c1.content <=> c2.content
      else
        created_at_ordering
      end
    end.each do |comment|
      output << import('FactlinkImport.comment',
        fields_from_object(comment, [:content, :created_at]).merge(
          fact_id: comment.fact_data.fact_id, username: comment.created_by.username)
      ) + " do\n"

      comment.sub_comments.each do |sub_comment|
        output << '  '
        output << import('sub_comment', fields_from_object(sub_comment, [:content, :created_at]).merge(
          username: sub_comment.created_by.username))
        output << "\n"
      end

      output << "end\n"
    end

    output
  end

  private

  def to_ruby(value)
    case value
    when Time
      return 'Time.parse(' + value.utc.iso8601.inspect + ')'
    when String, Integer, NilClass, TrueClass, FalseClass, Hash
      return value.inspect
    else
      fail "Unsupported type: " + value.class.name
    end
  end

  def name_value_to_string(name, value)
    name.to_s + ': ' + to_ruby(value) + ', '
  end

  def fields_from_object(object, field_names)
    field_names.inject({}) { |hash, name| hash.merge(name => object.public_send(name)) }
  end

  def import(name, fields)
    fields_string = fields.map{ |name, value| name_value_to_string(name, value)}.join

    "#{name}({#{fields_string}})"
  end
end
