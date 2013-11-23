class Match
  attr_accessor :match, :name, :rest
  def initialize(match, rest=nil)
    @match = match
    @rest = rest
  end
  def ==(a)
    if match.kind_of?(Array) && match[1] && match[1].match.kind_of?(Array)
      if !a.kind_of?(Array)
        false
      else
        match[0] == a[0] && match[1] == a[1..-1]
      end
    else
      match == a
    end
  end
end
class Rackus
  attr_accessor :parts, :const, :type, :name, :tokens, :match_found
  def |(other)
    if type == :enum
      @parts.push other
      self
    else
      (Or self, other)
    end
  end
  def +(other)
    if type == :join
      @parts.push other
      self
    else
      (And self, other)
    end
  end
  def test(string, tokens=nil)
    tokens ||= @tokens || {}
    if type == :enum
      parts.inject(false) { |a, x|
        a || x.test(string, @tokens)
      }
    elsif type == :const
      string == const
    elsif type == :token
      tokens[name].test string
    elsif type == :join
      read(string, tokens) != false
    else
      false
    end
  end
  def read(string, tokens={}, prefix=false)
    if type == :enum
      @match_found[parts] = false
      parts.inject(false) { |a, x|
        # TODO: this method of using only the first match will
	#       not be sufficient. a tree-crawler will be needed.
	if @match_found[parts]
	  a
	else
	  @match_found[parts] = x.read(string, @tokens == {} ? tokens : @tokens, prefix)
	  @match_found[parts]
	end
      }
    elsif type == :const
      if string.start_with?(const)
        rest = string.sub(const, "")
        (rest != "" && !prefix) ? 
	  false :  
	  Match.new(const, rest == "" ? nil : rest)
      else
        false 
      end
    elsif type == :token
      match = tokens[name].read string, tokens, true
      if match
        match.name = name
	match
      else
        false
      end
    elsif type == :join
      read_head = parts[0].read(string, tokens, true)
      chop = read_head ? read_head.rest : false
      if chop || parts.length == 1
        rest = self.clone
	rest.parts = parts[1..-1]
	if rest.parts.length > 0
	  tail = rest.read(chop, tokens, true)
	  if tail
	    Match.new([read_head, tail])
	  else
	    false
	  end
	else
	 read_head ? (read_head.rest == nil ? read_head : false) : false
	end
      else
        false
      end
    else
      false
    end
  end
  def initialize
    @tokens = {}
    @match_found = {}
  end
  def self.const(string)
    rack = self.new
    rack.const = string
    rack.type = :const
    rack
  end
  def self.make(parts)
    parts.map {|p|
      if p.is_a? Rackus
	p
      else
	self.const(p) 
      end
    }
  end
  def self.enum(*parts)
    rack = self.new
    rack.parts = self.make parts 
    rack.type = :enum
    rack
  end
  def self.token(name)
    rack = self.new
    rack.name = name
    rack.type = :token
    rack
  end
  def self.join(*parts)
    rack = self.new
    rack.parts = self.make parts
    rack.type = :join
    rack
  end

  def register!(name, token)
    @tokens[name] = token
  end
end

def Or(*args)
  Rackus.enum(*args)
end
def And(*args)
  Rackus.join(*args)
end
def Token(*args)
  Rackus.token(*args)
end
def Const(c)
  Rackus.const c
end
def get_variable(name)
  instance_name = name.to_s.prepend("@").to_sym
  p instance_name
  instance_variable_get(instance_name)
end

