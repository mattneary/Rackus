require './rackus.rb'

enum = Rackus.enum 'A', Rackus.join('A', Rackus.token(:enum))
enum.register! :enum, enum
p enum.test("C") == false
p enum.test("A") == true
p enum.test('AA') == true
p enum.test('AB') == false
p enum.test('CB') == false
