# Measurb

Handle units of measurment with ease! Measurb is a Ruby library for creating and managing units of measurements, or dimensions. Create your own units and define how to convert amongst them. Measurb also comes with a few default dimensions: inches, feet, and yards, but you don't have to use them. Measurb takes care of the tediousness of adding, subtracting, and comparing different measurements, especially between different units of measurement.

## Build Status
[![Build Status](https://travis-ci.org/jfairbank/measurb.svg?branch=master)](https://travis-ci.org/jfairbank/measurb)

## Installation

Add this line to your application's Gemfile:

    gem 'measurb'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install measurb

## Defining Dimensions

Measurb has a straightforward interface to defining dimensions. Just give `Measurb.define` a dimension name and optional block to define conversions.

```ruby
# Without conversions
Measurb.define :inches

# With conversion
Measurb.define :inches do
  feet  value / 12.0
  yards value / 36.0
end

Measurb.define :feet do
  inches value * 12.0
  yards  value / 3.0
end

Measurb.define :yards do
  feet   value * 3.0
  inches value * 36.0
end
```

You can specify an abbreviation for a dimension too.

```ruby
Measurb.define :ft, abbrev: 'ft'
```

## Using Dimensions

When you define a dimension, Measurb creates a dimension class that can be instantiated.

```ruby
Measurb.define :inches
forty_two_inches = Measurb::Inches.new(42)
```

Merb also defines a singleton method on itself and a method on `Numeric`, both of the same dimension name.

```ruby
two_inches   = Measurb.inches(2) # singleton method
three_inches = 3.inches          # Numeric method
```

If you defined an abbreviation, you can use it on `Numeric` as well.

```ruby
Measurb.define :ft, abbrev: 'ft'
5.feet == 5.ft #=> true
```

## Converting

To convert a dimension, you must have set up at least two dimensions, including the appropriate conversion formulas.

```ruby
Measurb.define :inches do
  feet value / 12.0
end

Measurb.define :feet do
  inches value * 12.0
end
```

For every conversion you set up in the definition block, Measurb will add a `to_*` method for that conversion.

```ruby
24.inches.to_feet == 2.feet
3.feet.to_inches  == 36.inches
```

## Arithmetic

Measurb supports addition and subtraction currently. You can perform operations amongst all the defined dimension classes. Make sure you've define your conversions beforehand, though! The resulting value will use the class of the leftmost operand.

```ruby
2.feet + 12.inches == 3.feet
3.feet - 6.inches  == 2.5.feet
3.yards - 1.feet   == 2.yards
```

## Equality and Comparisons

Measurb also supports all the typical equality and inequality checks `==`  `!=`  `<`  `>`  `<=`  `>=` `<=>`. They work correctly with other dimension classes too.

```ruby
42.feet == 42.feet  #=> true
2.feet < 26.inches  #=> true
3.feet > 2.yards    #=> false
24.inches <= 2.feet #=> true
5.feet <=> 2.yards  #=> -1
24.inches != 2.feet #=> false
```

`eql?` is also implemented, but it DOES depend on the same dimension class to be true

```ruby
2.feet.eql? 2.feet    #=> true
2.feet.eql? 24.inches #=> false
```

## Contributing

1. Fork it ( http://github.com/jfairbank/measurb/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
