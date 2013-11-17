class Match
  attr_accessor :match, :name
  def initialize(match)
    @match = match
  end
  def ==(a)
    match == a
  end
end
class Rackus
  attr_accessor :parts, :const, :type, :name, :tokens
  def test(string, tokens={})
    if type == :enum
      parts.inject(false) { |a, x|
        a || x.test(string, @tokens)
      }
    elsif type == :const
      string == const
    elsif type == :token
      tokens[name].test string
    elsif type == :join
      parts[0].test(string[0], tokens) && parts[1].test(string[1], tokens)
      read(string, tokens) != false
    else
      false
    end
  end
  def read(string, tokens={})
    if type == :enum
      parts.inject(false) { |a, x|
        a ? a : x.read(string, @tokens)
      }
    elsif type == :const
      if string.start_with?(const)
        rest = string.sub(const, "")
        Match.new([const].concat(rest == "" ? [] : [rest]))
      else
        false 
      end
    elsif type == :token
      match = tokens[name].read string
      if match
        match.name = name
	match
      else
        false
      end
    elsif type == :join
      read_head = parts[0].read(string, tokens)
      chop = read_head ? read_head.match.last : false
      if chop
        rest = self.clone
	rest.parts = parts[1..-1]
	if rest.parts.length > 0
	  tail = rest.read(chop, tokens)
	  if tail
	    Match.new([read_head.match.first].concat tail.match)
	  else
	    false
	  end
	else
	  read_head.match[1] ? false : Match.new([read_head.match.first])
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
  def self.join(a, b)
    rack = self.new
    rack.parts = self.make [a, b]
    rack.type = :join
    rack
  end

  def register!(name, token)
    @tokens[name] = token
  end
end

