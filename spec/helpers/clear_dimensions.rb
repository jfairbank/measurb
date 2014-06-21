def remove_loaded_default_dimensions
  $".delete_if do |file|
    file =~ %r{dims-rb/lib/dims/defaults}
  end
end

def clear_defined_dimension(name, abbrev)
  class_name = name.to_s.capitalize
  Dims.__send__(:remove_const, class_name) if Dims.const_defined?(class_name)
  Numeric.__send__(:undef_method, name)    if Numeric.method_defined?(name)
  Numeric.__send__(:undef_method, abbrev)  if Numeric.method_defined?(abbrev)
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
