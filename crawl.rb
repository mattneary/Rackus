class Parse
  attr_accessor :parse, :rest
end
class Pattern
  attr_accessor :type, :const, :parts
end
def Const(text)
  pattern = Pattern.new
  pattern.type = :const
  pattern.const = text
  pattern
end
def Chain(text)
  pattern = Pattern.new
  pattern.type = :chain
  pattern.parts = [Rackus.new(Const text), Rackus.new(pattern)]
  pattern
end

class Rackus
  def initialize(pattern)
    @pattern = pattern
  end
  def read(string)
    if @pattern.type == :const
      parse = Parse.new
      if string.start_with? @pattern.const
	parse.parse = @pattern.const
	parse.rest = string.sub Regexp.new(@pattern.const), '' # replace front 
      else
        parse.parse = nil
	parse.rest = string
      end
      parse
    else
      first = @pattern.parts.first.read(string)
      if first.rest == ""
        first
      else
        @pattern.parts.last.read(first.rest)
      end
    end
  end
end

