class Opinion
  
  # naming conventions as in the document describing the calculations
  # b = belief
  # d = disbeliefs
  # u = uncertain
  #
  # a = authority
  
  attr_accessor :b, :d, :u, :a
  
  def initialize(b,d,u,a=0)
    self.b=b
    self.d=d
    self.u=u
    self.a=a
    use_floats!
  end


  def Opinion.for_type(type, authority=0)
    case type
    when :beliefs
      Opinion.new(1,0,0,authority)
    when :disbeliefs
      Opinion.new(0,1,0,authority)
    when :doubts
      Opinion.new(0,0,1,authority)
    end
  end
  
  # inefficient, but allows for quickly changing the + def
  def Opinion.combine(list)
    unless list.length > 0
      Opinion.new(0,0,0)
    else
      a = list.inject(Opinion.new(0,0,0,0)) { | result, element |  result + element }
    end
  end

  #CHANGE ALONG WITH + !!!!
  def weight
    return (self.b + self.d + self.u)*self.a
  end

  #CHANGE weight ALONG WITH + !!!
  def +(second)
    second.use_floats!
    use_floats!
        
    a = self.a + second.a
    
    if a == 0
      # No authority
      return Opinion.new(0.1,0.1,0.1)
    end
    
    b = (self.b*self.a + second.b*second.a)/a
    d = (self.d*self.a + second.d*second.a)/a
    u = (self.u*self.a + second.u*second.a)/a
    return Opinion.new(b,d,u,a)
  end

  
  #TODO : better name
  def dfa(fr,fl)
    result = self.discount_by(fr).discount_by(fl)

    result.a = [fr.a, fl.a].min
    return result
  end
  
  def ==(other)
    self.a == other.a and
      self.b == other.b and
      self.d == other.d and
      self.u == other.u
  end

  protected
  def discount_by(fl)
    pu = self
        
    b = pu.b * fl.b
    d = pu.d * fl.b
    u = fl.d + fl.u + pu.u * fl.b
    return Opinion.new(b,d,u,a)
  end

  def use_floats!
    self.b = self.b.to_f
    self.d = self.d.to_f
    self.u = self.u.to_f
    self.a = self.a.to_f
  end
        
end
