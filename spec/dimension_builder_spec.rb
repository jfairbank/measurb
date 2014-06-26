require 'spec_helper'

describe Measurb::DimensionBuilder do
  describe '.get_dimension_class_name' do
    def m(name)
      Measurb::DimensionBuilder.get_dimension_class_name(name)
    end

    it 'generates the expected class name from a symbol' do
      expect(m(:feet)).to           eq('Feet')
      expect(m(:nautical_miles)).to eq('NauticalMiles')
    end

    it 'generates the expected class name from a string' do
      expect(m('feet')).to           eq('Feet')
      expect(m('nautical_miles')).to eq('NauticalMiles')
    end
  end
end
