12/31/2020

In Ruby, when you define a method in file scope, it is created as a private method on Object.
When I wrap the method in `T.unsafe` and then call it, I am able to pass sorbet checks my I fail at runtime.

```ruby
# typed: true
require 'sorbet-runtime'
extend T::Sig
def my_global_method(x)
  x + 1
end

puts my_global_method(3)  # => 4
T.unsafe(self).my_global_method(3, 4) # Outputs
  # private method `my_global_method' called for main:Object (NoMethodError)
```
