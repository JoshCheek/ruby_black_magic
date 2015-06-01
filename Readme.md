Object Model C Extension
========================

Warning
-------

This is *not* for use in anything you give a shit about...
expect segfaults.


Examples
--------

You will need to require the lib to run these.
On mine, I did it like this: `require '/Users/josh/code/object_model_c_extension/lib/object_model'`
But your location will be different (see installation instructions at the bottom)

Get the real class of an object, not whatever Ruby tells you.

```ruby
o = Object.new
ObjectModel.real_class o # => Object
def o.zomg; end
ObjectModel.real_class o # => #<Class:#<Object:0x007fb0531cf7e0>>
```

See the set of places Ruby will look for methods.

```ruby
ObjectModel.ancestry "a"
# => [String,
#     #<ObjectModel::IncludedClass:0x007f9deb11f6a8 @wrapped=Comparable>,
#     Object,
#     #<ObjectModel::IncludedClass:0x007f9deb11f630 @wrapped=PP::ObjectMixin>,
#     #<ObjectModel::IncludedClass:0x007f9deb11f608 @wrapped=Kernel>,
#     BasicObject]
```

The actual superclass of a class.

```ruby
# The superclass of BasicObject and modules is actually `false`!
ObjectModel.real_superclass Class       # => Module
ObjectModel.real_superclass BasicObject # => false
ObjectModel.real_superclass Module.new  # => false
```

Defining constants with invalid names :P

```ruby
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

Swap out the class!

```ruby
# Don't do this with builtins,
# their C-structure is too different,
# could crash your Ruby pretty hard :P

class HasLastName
  def initialize(last_name)
    @last_name = last_name
  end

  def name
    "Unknown #{@last_name}"
  end
end

class FirstnameJohn
  def name
    "John #{@last_name}"
  end
end

class FirstnameJane
  def name
    "Jane #{@last_name}"
  end
end

o = HasLastName.new 'Doe'
o.class # => HasLastName
o.name  # => "Unknown Doe"

ObjectModel.set_class o, FirstnameJohn
o.class # => FirstnameJohn
o.name  # => "John Doe"

ObjectModel.set_class o, FirstnameJane
o.class # => FirstnameJane
o.name  # => "Jane Doe"
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


Inspiration
-----------

* [Change Class](https://github.com/seattlerb/change_class)
* [Base](https://github.com/garybernhardt/base)
* [This gist](https://gist.github.com/JoshCheek/4574453) from way back in the day.


License
-------

[Just do what the fuck you want to.](http://www.wtfpl.net/about/)

[But don't blame me](http://en.wikipedia.org/wiki/MIT_License#License_terms)
