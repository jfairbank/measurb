module Dims
  class Dimension
    attr_reader :value, :precision

    class << self
      attr_reader :abbrev, :dimension_name
    end

    def initialize(value, precision = DEFAULT_PRECISION)
      @precision      = precision
      @original_value = value
      @value          = fix_value(value, precision)
    end

    def value
      modifier = (10 ** @precision).to_f
      (@value * modifier).round / modifier
    end

    # Define arithmetic operations
    %w(+ -).each do |op|
      class_eval <<-EOS, __FILE__, __LINE__ + 1
        def #{op}(other)
          self.class.new(value #{op} to_self(other).value)
        end
      EOS
    end

    # Define equality expressions
    %w(== != < > <= >=).each do |op|
      class_eval <<-EOS, __FILE__, __LINE__ + 1
        def #{op}(other)
          value #{op} to_self(other).value
        end
      EOS
    end

    def eql?(other)
      self.class == other.class && self == other
    end

    def inspect
      "#{value} #{self.class.abbrev || self.class.dimension_name}"
    end

    private

    def to_self(other)
      other.__send__("to_#{self.class.dimension_name}")
    end

    def fix_value(value, precision)
      modifier = (10 ** precision).to_f
      (value * modifier).round / modifier
    end
  end
end
