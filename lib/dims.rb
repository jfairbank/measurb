require 'dims/version'
require 'dims/config'
require 'dims/core_ext'
require 'dims/dimension'
require 'dims/dimension_builder'

module Dims
  DEFAULT_PRECISION = 2

  class << self
    def define(name, options = {}, &block)
      builder = DimensionBuilder.new(name, options, &block)

      if const_defined?(builder.dimension_class_name)
        raise NameError, "Already defined dimension class `#{builder.dimension_class_name}`"
      end

      const_set(builder.dimension_class_name, builder.dimension_class)
      CoreExt.add_numeric_dimension(name, builder.dimension_class_name, builder.dimension_class.abbrev)
      builder.dimension_class
    end

    def configure
      yield config
    end

    def config
      @config ||= Config.new
    end
  end
end
