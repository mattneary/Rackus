require './rackus.rb'

simple = And 'A', 'B'

p simple.test('A') == false
p simple.test('B') == false
p simple.test('AB') == true
p simple.read('AB') == ['A', 'B']
p simple.test('ACB') == false
p simple.test('ABC') == false

enum = Or 'A', (And 'A', (Token :enum))
enum.register! :enum, enum

p enum.test("C") == false
p enum.test("A") == true
p enum.read("A") == "A"
p enum.test('AA') == true
p enum.read('AA') == ["A", "A"]
p enum.test('AB') == false
p enum.test('CB') == false

string = And 'A', 'B', 'C'

p string.test('ABC') == true
p string.read('ABC') == ['A', 'B', 'C']
p string.test('AB') == false
p string.test('ABCD') == false

regular = And (Token :a), (Token :b), (Token :a)
regular.register! :a, (Rackus.const 'A')
regular.register! :b, (Or 'B', (And 'B', (Token :b)))

p regular.test('ABA') == true
p regular.test('ABC') == false
p regular.test('ACB') == false

dslOr = (Rackus.const 'A') | (Rackus.const 'B') | (Rackus.const 'C')
p dslOr.test('A') == true
p dslOr.test('B') == true
p dslOr.test('D') == false

dslAnd = (Rackus.const 'A') + (Rackus.const 'B') + (Rackus.const 'C')
p dslAnd.test('ABC') == true
p dslAnd.test('ACB') == false
p dslAnd.test('ABD') == false

