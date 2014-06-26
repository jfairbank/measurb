require 'measurb/version'
require 'measurb/config'
require 'measurb/core_ext'
require 'measurb/dimension'
require 'measurb/dimension_builder'

# Main module
module Measurb
  DEFAULT_PRECISION = 3

  # Error when attempting to define a dimension that already exists
  class DuplicateDimensionError < NameError; end

  class << self
    # Define a new dimension class and helper singleton method
    #
    # @api public
    #
    # @example Without conversions
    #   Measurb.define :inches
    #
    # @example With conversions
    #   Measurb.define :inches do
    #     feet value / 12.0
    #   end
    #
    #   Measurb.define :feet do
    #     inches value * 12.0
    #   end
    #
    # @param name [Symbol, String]     Name of the dimension
    # @return     [Measurb::Dimension] A subclass of {Measurb::Dimension}
    def define(name, options = {}, &block)
      # Check if the dimension has already been defined
      if dimension_exists?(name)
        raise DuplicateDimensionError,
          "Already defined dimension class `#{DimensionBuilder.get_dimension_class_name(name)}`"
      end

      # Create the dimension builder
      builder = DimensionBuilder.new(name, options, &block)

      # Add the class constant and helper method to the module
      const_set(builder.dimension_class_name, builder.dimension_class)
      add_dimension_method(name, builder.dimension_class_name)

      # Add the helper methods to 'Numeric'
      CoreExt.add_numeric_dimension(name, builder.dimension_class_name, builder.dimension_class.abbrev)

      builder.dimension_class
    end

    # Configure {Measurb} with {Config}
    #
    # @api public
    #
    # @example
    #   Measurb.configure do |config|
    #     config.enable_defaults :inches, :feet
    #   end
    #
    # @return [nil]
    def configure
      yield config
    end

    # Check if the dimension already exists
    #
    # @api public
    #
    # @example
    #   Measurb.configure { |config| config.enable_defaults(:inches) }
    #
    #   Measurb.dimension_exists?(:inches) #=> true
    #   Measurb.dimension_exists?(:feet)   #=> false
    #
    # @param name [Symbol, String] Name of the dimension
    # @return     [Boolean]
    def dimension_exists?(name)
      const_defined?(DimensionBuilder.get_dimension_class_name(name))
    end

    private

    # Config object used by {#configure}
    #
    # @api private
    #
    # @return [Config] The configurable object
    def config
      @config ||= Config.new
    end

    # Create the dimension class singleton method
    #
    # @api private
    #
    # @param name                 [Symbol, String] Name of the dimension
    # @param dimension_class_name [String]         Name of the dimension class
    # @return                     [Symbol, nil]    Return type based on ruby version
    def add_dimension_method(name, dimension_class_name)
      instance_eval <<-EOS, __FILE__, __LINE__ + 1
        def #{name}(value, precision = DEFAULT_PRECISION)
          #{dimension_class_name}.new(value, precision)
        end
      EOS
    end
  end
end
