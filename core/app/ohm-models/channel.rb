require File.join(File.dirname(__FILE__), "channel", "generated_channel")
require File.join(File.dirname(__FILE__), "channel", "created_facts")
require File.join(File.dirname(__FILE__), "channel", "user_stream")

class Channel < OurOhm
  
  include ActivitySubject
  
  attribute :title
  index :title
  attribute :description

  reference :created_by, GraphUser
  alias :graph_user :created_by

  private
  set :contained_channels, Channel

  timestamped_set :sorted_internal_facts, Fact
  timestamped_set :sorted_delete_facts, Fact
  timestamped_set :sorted_cached_facts, Fact

  delegate :unread_count, :mark_as_read, :to => :sorted_cached_facts

  public
  alias :sub_channels :contained_channels

  def prune_invalid_facts
    [sorted_internal_facts, sorted_delete_facts].each do |facts|
      facts.each do |fact|
        if Fact.invalid(fact)
          facts.delete(fact)
        end
      end
    end
  end

  def calculate_facts
    prune_invalid_facts
    fs = sorted_internal_facts
    contained_channels.each do |ch|
      fs |= ch.sorted_cached_facts
    end
    fs -= sorted_delete_facts
    self.sorted_cached_facts = fs
    return self.sorted_cached_facts
  end


  attribute :discontinued
  index :discontinued
  def delete
    self.discontinued = true
    save
  end

  def facts
    return [] if new?

    sorted_cached_facts.all.delete_if{ |f| Fact.invalid(f) }
  end
  
  def validate
    execute_callback(:before, :validate) # needed because of ugly ohm contrib callbacks
    super
    assert_present :title
    assert_present :created_by
    execute_callback(:after, :validate) # needed because of ugly ohm contrib callbacks
  end

  def add_fact(fact)
    self.sorted_delete_facts.delete(fact)
    self.sorted_internal_facts.add(fact)
    self.sorted_cached_facts.add(fact)
    activity(self.created_by,:added,fact,:to,self)
  end

  def remove_fact(fact)
    self.sorted_internal_facts.delete(fact) if self.sorted_internal_facts.include?(fact)
    self.sorted_cached_facts.delete(fact)   if self.sorted_cached_facts.include?(fact)
    self.sorted_delete_facts.add(fact)
    activity(self.created_by,:removed,fact,:from,self)
  end

  def to_s
    self.id
  end
  
  
  def include?(obj)
    self.sorted_cached_facts.include?(obj)
  end
  
  def editable?
    true
  end
  
  def followable?
    true
  end

  def fork(user)
    c = Channel.create(:created_by => user, :title => title, :description => description)
    c._add_channel(self)
    activity(user,:forked,self,:to,c)
    c
  end

  def related_users(calculator=RelatedUsersCalculator.new,options)
    options[:without] ||= []
    options[:without] << created_by
    calculator.related_users(facts,options)
  end
  
  def to_hash
    return {:id => id, 
            :title => title, 
            :description => description,
            :created_by => created_by,
            :discontinued => discontinued}
  end

  def add_channel(channel)
    _add_channel(channel)
    activity(self.created_by,:added,channel,:to,self)
  end

  protected
  def _add_channel(channel)
    contained_channels << channel
    calculate_facts
  end

  def self.recalculate_all
    all.andand.each do |ch|
      ch.calculate_facts
    end
  end



end