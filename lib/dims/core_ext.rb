module Dims
  module CoreExt
    def self.add_numeric_dimension(name, dimension_class_name, abbrev)
      def_string = <<-EOS
        def #{name}(precision = #{DEFAULT_PRECISION})
          Dims::#{dimension_class_name}.new(self, precision)
        end
      EOS

      unless abbrev.nil?
        def_string << "\nalias_method :#{abbrev}, :#{name}"
      end

      Numeric.class_eval(def_string)
    end
  end
end
