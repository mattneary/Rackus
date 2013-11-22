# Rackus
Rackus allows Backus-Naur defined grammars to be tested and read
in Ruby. Currently, a DSL is used to define these grammars. Eventually,
it will become a self-hosted grammar parser which uses true BNF as input.

## Getting Started
Rackus is a lot like Regular Expressions, except more appropriate for
parsers. Require the library to get started.

```ruby
require './rackus.rb'
```

Form an expression pattern using `And`, `Or`, and `Token` 
(together with `Rackus#register!`). Here's a very basic example.

```ruby
alphabeta = (Const 'A') | (Const 'B')
alphabeta.test 'A' # => true
alphabeta.test 'B' # => true
alphabeta.test 'C' # => false
```

More complicated expressions arise by use of recursion. Here is an example
of this approach.

```ruby
bs = (Const 'B') | ((Const 'B') + (Token :b))
bs.register! :b, bs

bs.test 'b' # => true
bs.test 'bb' # => true
bs.test 'bbbb' # => true
bs.test 'bab' # => false
```

## Parsing
Rackus is not limited to RegEx-like testing. Rather, Rackus can be used
to extract structure from strings. This is done by use of `Rackus#read`.
Let's look at an example, in which we use Rackus to analyze a grammar.

```ruby
sum = (Token :bit) + (Token :op) + ((Token :sum) | (Token :bit))
sum.register! :bit, (Or '0', '1')
sum.register! :op, (Or '+', '*', '-')
sum.register! :sum, sum

sum.read('0+1').map(&:name) == [:bit, :op, :bit] # => true
sum.read('0+1+0').map(&:name) == [:bit, :op, :bit] # => false
```

