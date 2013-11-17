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
alphabeta = Or 'A', 'B'
alphabeta.test 'A' # => true
alphabeta.test 'B' # => true
alphabeta.test 'C' # => false
```

More complicated expressions arise by use of recursion. Here is an example
of this approach.

```ruby
bs = Or 'B', (And 'B', Token(:b))
bs.register! :b, bs

bs.test 'b' # => true
bs.test 'bb' # => true
bs.test 'bbbb' # => true
bs.test 'bab' # => false
```

