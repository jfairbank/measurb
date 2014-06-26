module Measurb
  # Base class for defined dimensions to inherit from.
  class Dimension
    include Comparable

    attr_reader :value, :precision

    class << self
      attr_reader :abbrev, :dimension_name
    end

    # Initialize the dimension
    #
    # @param value     [Numeric] Numeric value to wrap
    # @param precision [Integer] Precision of decimal places
    # @return          [Measurb::Dimension]
    def initialize(value, precision = DEFAULT_PRECISION)
      @precision      = precision
      @original_value = value
      @value          = fix_value(value, precision)
    end

    # Add another dimension
    #
    # @param other [Measurb::Dimension]
    # @return      [Measurb::Dimension]
    def +(other)
      arithmetic(:+, other)
    end

    # Subtract another dimension
    #
    # @param other [Measurb::Dimension]
    # @return      [Measurb::Dimension]
    def -(other)
      arithmetic(:-, other)
    end

    # Compare with another dimension
    #
    # @param other [Measurb::Dimension]
    # @return      [-1, 0, 1]
    def <=>(other)
      value <=> to_self(other).value
    end

    # Check type and value quality with another dimension
    #
    # @param other [Measurb::Dimension]
    # @return      [Boolean]
    def eql?(other)
      self.class == other.class && self == other
    end

    # Get the inspect string
    #
    # @return [String]
    def inspect
      "#{value} #{self.class.abbrev || self.class.dimension_name}"
    end

    private

    # Perform an arithmetic operation `name` with `other`, keeping the
    # smallest precision of the two dimensions.
    #
    # @param op    [Symbol] Name of the arithmetic operation
    # @param other [Measurb::Dimension]
    # @return      [Measurb::Dimension]
    def arithmetic(op, other)
      least_precision = [precision, other.precision].min
      new_value = value.__send__(op, to_self(other).value)
      self.class.new(new_value, least_precision)
    end

    # Coerce other dimension to own class
    #
    # @param other [Measurb::Dimension]
    # @return      [self.class]
    def to_self(other)
      other.__send__("to_#{self.class.dimension_name}")
    end

    # Adjust a value to a given decimal precision
    #
    # @param value     [Numeric]
    # @param precision [Integer] Precision of decimal places
    def fix_value(value, precision)
      modifier = (10 ** precision).to_f
      (value * modifier).round / modifier
    end
  end
end
