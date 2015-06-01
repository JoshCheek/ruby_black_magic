Object Model C Extension
========================

Example
-------

```ruby
require "/Users/josh/.gists/4574453/lib/object_model"

# See the real class of an object!
o = Object.new
ObjectModel.real_class o # => Object
def o.zomg; end
ObjectModel.real_class o # => #<Class:#<Object:0x007f9deb11fba8>>


# See the actual ancestry of an object!
ObjectModel.ancestry "a"
# => [String,
#     #<ObjectModel::IncludedClass:0x007f9deb11f6a8 @wrapped=Comparable>,
#     Object,
#     #<ObjectModel::IncludedClass:0x007f9deb11f630 @wrapped=PP::ObjectMixin>,
#     #<ObjectModel::IncludedClass:0x007f9deb11f608 @wrapped=Kernel>,
#     BasicObject]


# The superclass of BasicObject and modules is actually `false`!
ObjectModel.real_superclass Class       # => Module
ObjectModel.real_superclass BasicObject # => false
ObjectModel.real_superclass Module.new  # => false

# Defining constants with invalid names :P
# You can do this with instance variables, too, btw.
A = Class.new
Wtf.lol(A) # => Wtf::lol
   .new    # => #<Wtf::lol:0x007f9deb117f70>
   .class  # => Wtf::lol
   .new    # => #<Wtf::lol:0x007f9deb117bb0>

# Ruby won't show it to you, though, b/c its name is invalid
Wtf.lol A   # => Wtf::lol
A.constants # => []
```

Install
-------

```sh
$ git clone git@github.com:JoshCheek/object_model_c_extension.git
$ cd object_model_c_extension/
$ bundle install
$ bundle exec rake compile:object_model
$ ruby -r ./lib/object_model.bundle -e 'p ObjectModel.ancestry "omg"'
```

License
-------

[Just do what the fuck you want to.](http://www.wtfpl.net/about/)
