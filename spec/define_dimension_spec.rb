require 'spec_helper'

describe Measurb do
  describe '.define' do
    before :example do
      clear_defined_inches
    end

    shared_context 'adding the Numeric method' do |method, options = {}|
      it 'adds the Numeric method' do
        int   = 42
        float = 3.14

        expect { int.__send__(method) }.to   raise_error(NoMethodError)
        expect { float.__send__(method) }.to raise_error(NoMethodError)

        Measurb.define(:inches, options)

        expect(int.__send__(method)).to   eq(Measurb::Inches.new(int))
        expect(float.__send__(method)).to eq(Measurb::Inches.new(float))
      end
    end

    it 'creates the class' do
      expect { Measurb::Inches }.to raise_error(NameError)
      Measurb.define(:inches)
      expect(Measurb::Inches).to be < Measurb::Dimension
    end

    it 'adds the helper method' do
      expect(Measurb).to_not respond_to(:inches)
      Measurb.define(:inches)
      expect(Measurb).to respond_to(:inches)
    end

    it 'returns the dimension class' do
      expect(Measurb.define(:inches)).to be(Measurb::Inches)
    end

    it 'raises an error if the class is already defined' do
      Measurb.define(:inches)

      expect {
        Measurb.define(:inches)
      }.to raise_error(Measurb::DuplicateDimensionError, 'Already defined dimension class `Inches`')
    end

    include_context 'adding the Numeric method', :inches

    context 'with `abbrev` option' do
      include_context 'adding the Numeric method', :in, abbrev: 'in'
    end
  end
end
