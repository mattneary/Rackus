require './rackus.rb'

simple = And 'A', 'B'

p simple.test('A') == false
p simple.test('B') == false
p simple.test('AB') == true
p simple.read('AB') == ['A', 'B']
p simple.test('ACB') == false
p simple.test('ABC') == false

enum = Or 'A', And('A', Token(:enum))
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
p string.test('AB') == false
p string.test('ABCD') == false

