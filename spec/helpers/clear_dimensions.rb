def remove_loaded_default_dimensions
  $".delete_if do |file|
    file =~ %r{measurb/lib/measurb/defaults}
  end
end

def clear_defined_dimension(name, abbrev)
  class_name = name.to_s.capitalize

  Measurb.singleton_class.__send__(:remove_method, name) if Measurb.singleton_class.method_defined?(name)
  Measurb.__send__(:remove_const, class_name)            if Measurb.const_defined?(class_name)
  Numeric.__send__(:remove_method, name)                 if Numeric.method_defined?(name)
  Numeric.__send__(:remove_method, abbrev)               if Numeric.method_defined?(abbrev)
end

def clear_defined_inches
  clear_defined_dimension(:inches, :in)
end

def clear_defined_feet
  clear_defined_dimension(:feet, :ft)
end

def clear_defined_yards
  clear_defined_dimension(:yards, :yd)
end
