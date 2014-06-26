module Measurb
  # Module for extending core classes
  module CoreExt
    # Add the dimension name method to `Numeric`
    #
    # @api semipublic
    #
    # @example
    #   42.respond_to?(:inches) #=> false
    #
    #   Measurb::CoreExt.add_numeric_dimension(:inches, 'Inches', 'in')
    #
    #   42.respond_to?(:inches) #=> true
    #
    # @param name                 [Symbol, String] Name of the dimension
    # @param dimension_class_name [String]         Name of the dimension class
    # @param abbrev               [String]         Abbreviation for the dimension name
    # @return                     [nil]
    def self.add_numeric_dimension(name, dimension_class_name, abbrev)
      def_string = <<-EOS
        def #{name}(precision = #{DEFAULT_PRECISION})
          Measurb::#{dimension_class_name}.new(self, precision)
        end
      EOS

      unless abbrev.nil?
        def_string << "\nalias_method :#{abbrev}, :#{name}"
      end

      Numeric.class_eval(def_string)
    end
  end
end
