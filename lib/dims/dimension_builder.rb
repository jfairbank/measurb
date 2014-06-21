module Dims
  class DimensionBuilder
    attr_reader :dimension_class_name, :value

    def initialize(name, options = {}, &block)
      @name                 = name
      @def_block            = block
      @options              = options
      @dimension_class_name = get_dimension_class_name(name)
    end

    def dimension_class
      build_dimension_class unless defined?(@dimension_class)
      @dimension_class
    end

    def method_missing(name, *args, &block)
      build_default_conversion(name, args.first)
    end

    private

    def get_dimension_class_name(name)
      name.to_s.split('_').map(&:capitalize).join
    end

    def build_default_conversion(name, conversion)
      class_name = get_dimension_class_name(name)

      build_conversion(name) do |precision = nil|
        precision ||= self.precision
        Dims.const_get(class_name).new(instance_eval(&conversion), precision)
      end
    end

    def build_conversion(name, &block)
      @dimension_class.__send__(:define_method, "to_#{name}", &block)
    end

    def build_dimension_class
      @value           = ValueProxy.new
      @dimension_class = Class.new(Dimension)

      @dimension_class.instance_variable_set(:@dimension_name, @name.to_s)
      @dimension_class.instance_variable_set(:@abbrev,         @options[:abbrev])

      instance_eval(&@def_block) unless @def_block.nil?

      # Return self when converting to same dimension unless changing precision
      build_conversion(@name) do |precision = nil|
        if precision.nil? || precision == self.precision
          self
        else
          self.class.new(value, precision)
        end
      end
    end

    class ValueProxy
      def *(convert_value)
        proc { value * convert_value }
      end

      def /(convert_value)
        proc { value / convert_value }
      end
    end
  end
end
