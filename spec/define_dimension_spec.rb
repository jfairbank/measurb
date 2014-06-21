require 'spec_helper'

describe Dims do
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

        Dims.define(:inches, options)

        expect(int.__send__(method)).to   eq(Dims::Inches.new(int))
        expect(float.__send__(method)).to eq(Dims::Inches.new(float))
      end
    end

    it 'creates the class' do
      expect { Dims::Inches }.to raise_error(NameError)
      Dims.define(:inches)
      expect(Dims::Inches).to be < Dims::Dimension
    end

    it 'returns the dimension class' do
      expect(Dims.define(:inches)).to be(Dims::Inches)
    end

    it 'raises an error if the class is already defined' do
      Dims.define(:inches)
      expect { Dims.define(:inches) }.to raise_error(NameError, 'Already defined dimension class `Inches`')
    end

    include_context 'adding the Numeric method', :inches

    context 'with `abbrev` option' do
      include_context 'adding the Numeric method', :in, abbrev: 'in'
    end
  end
end
