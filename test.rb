require './rackus.rb'

simple = Rackus.join 'A', 'B'

p simple.test('A') == false
p simple.test('B') == false
p simple.test('AB') == true && simple.read('AB') == ['A', 'B']
p simple.test('ACB') == false
p simple.test('ABC') == false

enum = Rackus.enum 'A', Rackus.join('A', Rackus.token(:enum))
enum.register! :enum, enum

p enum.test("C") == false
p enum.test("A") == true && enum.read("A") == "A"
p enum.test('AA') == true && enum.read('AA') == ["A", "A"]
p enum.test('AB') == false
p enum.test('CB') == false

