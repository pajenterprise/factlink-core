class Ohm::Model::TimestampedSet < Ohm::Model::SortedSet
  def self.current_time(time=nil)
    time ||= DateTime.now
    (time.to_time.to_f*1000).to_i
  end
  def initialize(*args)
    super(*args) do |f|
      self.class.current_time
    end
  end

  def below(limit,opts={})
    if opts[:count]
      redis_opts = { limit: [0, opts[:count]] }
    else
      redis_opts = {}
    end

    redis_opts[:withscores] = opts[:withscores]

    res = key.zrevrangebyscore("(#{limit}", '-inf', redis_opts)

    if opts[:withscores]
      res = self.class.hash_array_for_withscores(res).map { |x| { item: model[x[:item]], score: x[:score] } }
    else
      res = res.map { |x| model[x] }
    end
    opts[:reversed]? res : res.reverse
  end

  def self.hash_array_for_withscores flat_array
    array_of_pairs = flat_array.each_slice(2)

    array_of_pairs.map do |pair|
      {item: pair[0], score: pair[1].to_f}
    end
  end

  def ids
    key.zrange(0, -1)
  end

  def inspect
    "#<TimestampedSet (#{model}): #{key.zrange(0,-1).inspect}>"
  end
end
