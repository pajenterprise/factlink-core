require 'pavlov'

module Queries
  class UserByUsername
    include Pavlov::Query
    arguments :username
    attribute :pavlov_options, Hash, default: {}

    def validate
      validate_regex :username, username, /\A[A-Za-z0-9_]*\Z/i,
                    "should consist of alphanumerical characters"
    end

    def execute
      User.find_by(username: /^#{username.downcase}$/i)
    end
  end
end
