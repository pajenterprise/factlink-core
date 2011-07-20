require File.expand_path("../fact.rb", __FILE__)

class GraphUser < OurOhm
  reference :user, lambda { |id| User.find(id) }

  # Authority of the user
  def authority
    1.0
  end
  set :facts, Fact
  
end