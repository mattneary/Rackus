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
