module Measurb
  # Factory class for building new dimension classes
  class DimensionBuilder
    attr_reader :dimension_class_name, :value

    # Get an appropriate class name for a dimension name
    #
    # @param name [Symbol, String] Name of the dimension
    # @return     [String]         Name of the dimension class
    def self.get_dimension_class_name(name)
      name.to_s.split('_').map(&:capitalize).join
    end

    # Initialize the builder
    #
    # @param  name    [Symbol, String] Name of the dimension
    # @param  options [Hash]
    # @option options [String]         :abbrev (nil) The dimension abbreviation
    # @param  block   [Proc]           Block for defining conversions to other dimensions
    def initialize(name, options = {}, &block)
      @name                 = name
      @def_block            = block
      @options              = options
      @dimension_class_name = self.class.get_dimension_class_name(name)
    end

    # @!attribute [r] dimension_class
    # Get the dimension class, creating it if it's not available
    # @return [Measurb::Dimension]
    def dimension_class
      build_dimension_class unless defined?(@dimension_class)
      @dimension_class
    end

    # Use to build conversion methods to other dimensions
    def method_missing(name, *args, &block)
      build_default_conversion(name, args.first)
    end

    private

    # Build a conversion to another dimension with a default implementation
    #
    # @param name       [Symbol, String] Name of the dimension
    # @param conversion [Proc]           Proc to convert the actual value
    def build_default_conversion(name, conversion)
      class_name = self.class.get_dimension_class_name(name)

      build_conversion(name) do
        precision ||= self.precision
        Measurb.const_get(class_name).new(instance_eval(&conversion), precision)
      end
    end

    # Build a conversion method, using `block` as the body
    #
    # @param name  [Symbol, String] Name of the dimension
    # @param block [Proc]           Conversion method body
    def build_conversion(name, &block)
      @dimension_class.__send__(:define_method, "to_#{name}", &block)
    end

    # Build the dimension class, defining any conversions from `@def_block` and
    # defining a default conversion to itself
    def build_dimension_class
      @value           = ValueProxy.new
      @dimension_class = Class.new(Dimension)

      @dimension_class.instance_variable_set(:@dimension_name, @name.to_s)
      @dimension_class.instance_variable_set(:@abbrev,         @options[:abbrev])

      instance_eval(&@def_block) unless @def_block.nil?

      # Return self when converting to same dimension
      build_conversion(@name) { self }
    end

    # Placeholder class in definition blocks for writing straightforward conversion syntax.
    # Currently only supports multiplication and division.
    #
    # ==== Examples
    #
    #    Measurb.define :inches do
    #      feet value / 12.0
    #    end
    #
    #    Measurb.define :feet do
    #      inches value * 12.0
    #    end
    class ValueProxy
      # Handle a conversion by multiplication
      #
      # @param convert_value [Float]
      # @return              [Proc] Proc to be used as the body for the conversion method on the {Dimension dimension class}
      def *(convert_value)
        proc { value * convert_value }
      end

      # Handle a conversion by division
      #
      # @param convert_value [Float]
      # @return              [Proc] Proc to be used as the body for the conversion method on the {Dimension dimension class}
      def /(convert_value)
        proc { value / convert_value }
      end
    end
  end
end
