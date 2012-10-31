require 'hashie'

module KillObject
  def self.dead_object(name, fields)
    self.class.send(:define_method, name) do |*args|
      alive_object, extra_fields = *args
      kill alive_object, fields, extra_fields || {}
    end
  end

  dead_object :conversation, [:id, :fact_data_id, :fact_id, :recipient_ids]
  dead_object :message, [:id, :created_at, :updated_at, :content, :sender_id]
  dead_object :user, [:id, :name, :username, :location, :biography, :gravatar_hash, :email, :receives_mailed_notifications]

  def self.kill alive_object, take_fields, extra_fields={}
    hash = {}
    take_fields.each do |key|
      hash[key] = alive_object.send(key) if alive_object.respond_to? key
    end
    Hashie::Mash.new(hash.merge extra_fields)
  end
end
