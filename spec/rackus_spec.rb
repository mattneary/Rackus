require './rackus.rb'

describe Rackus, "#test" do
  it "verifies a basic constant" do
    const = Const 'A'
    const.test('B').should be false
    const.test('A').should be true
  end
  it "verifies constant join" do
    join = (Const 'A') + (Const 'B')
    join.test('A').should be false
    join.test('AC').should be false
    join.test('AB').should be true
  end
  it "verifies a recursive chain" do
    enum = (Const 'A') | ((Const 'A') + (Token :enum))
    enum.register! :enum, enum
    enum.test('C').should be false
    enum.test('A').should be true
    enum.test('AA').should be true
    enum.test('AB').should be false
    enum.test('AC').should be false
  end
  it "verifies multiple const join" do
    multiple = (Const 'A') + (Const 'B') + (Const 'C')
    multiple.test('A').should be false
    multiple.test('AB').should be false
    multiple.test('ABC').should be true
    multiple.test('ABCD').should be false
  end
  it "verifies a regular language tree" do
    regular = (Token :a) + (Token :b) + (Token :a)
    regular.register! :a, (Const 'A')
    regular.register! :b, ((Const 'B') | ((Const 'B') + (Token :b)))
    regular.test('ABA').should be true
    regular.test('ABC').should be false
    regular.test('ACB').should be false
    # FAILS: regular.test('ABBA').should be true
  end
  it "verifies star quantifier" do
    chain = ~(Const 'A')	
    chain.test('A').should be true
    chain.test('AB').should be false
    chain.test('AA').should be true
    chain.test('AAB').should be false
    # FAILS: chain.test('AAA').should be true	
  end
end
