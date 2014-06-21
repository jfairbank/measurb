RSpec::Matchers.define :have_method do |expected|
  match do |actual|
    actual.method_defined?(expected)
  end
end

RSpec::Matchers.define :have_value do |expected|
  match do |actual|
    actual.value == expected
  end
end

RSpec::Matchers.define :have_precision do |expected|
  match do |actual|
    actual.precision == expected
  end
end
