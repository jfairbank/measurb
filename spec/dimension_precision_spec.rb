require 'spec_helper'

describe Dims::Dimension do
  describe '.new' do
    before :context do
      clear_defined_inches
      clear_defined_feet
      clear_defined_yards
      remove_loaded_default_dimensions

      Dims.configure do |config|
        config.enable_defaults :inches, :feet
      end
    end

    let(:default_precision)  { 2 }
    let(:supplied_precision) { 3 }

    let(:int)             { Dims::Inches.new(42) }
    let(:int_precision)   { Dims::Inches.new(42, supplied_precision) }
    let(:float)           { Dims::Inches.new(Math::PI) }
    let(:float_precision) { Dims::Inches.new(Math::PI, supplied_precision) }

    context 'without precision supplied' do
      it 'uses the default precision' do
        expect(int).to   have_precision(default_precision)
        expect(float).to have_precision(default_precision)
      end

      it 'keeps the same precision when converted' do
        expect(int.to_feet).to   have_precision(int.precision)
        expect(float.to_feet).to have_precision(float.precision)
      end

      it 'sets the value based on the precision' do
        expect(int).to       have_value(42.0)
        expect(int).to       have_value(42)
        expect(float).to     have_value(3.14)
        expect(float).to_not have_value(Math::PI)
      end
    end

    context 'with precision supplied' do
      it 'uses the supplied precision' do
        expect(int_precision).to   have_precision(supplied_precision)
        expect(float_precision).to have_precision(supplied_precision)
      end

      it 'keeps the same precision when converted' do
        expect(int_precision.to_feet).to   have_precision(int_precision.precision)
        expect(float_precision.to_feet).to have_precision(float_precision.precision)
      end

      it 'sets the value based on the precision' do
        expect(int_precision).to       have_value(42.0)
        expect(int_precision).to       have_value(42)
        expect(float_precision).to     have_value(3.142)
        expect(float_precision).to_not have_value(3.14)
        expect(float_precision).to_not have_value(Math::PI)
      end
    end

    pending 'handle conversions with supplied precisions'
    pending 'handle arithmetic with least significant precision'
  end
end
