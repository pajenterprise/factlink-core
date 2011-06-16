class Site
  include Mongoid::Document
  field :url

  has_many :factlink_tops   # Getting deprecated
  has_many :factlinks       # Moving to this
  
  validates_presence_of :url
  validates_uniqueness_of :url
  
end