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

    let(:default_precision)  { Dims::DEFAULT_PRECISION }
    let(:supplied_precision) { 2 }

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
        expect(float).to     have_value(3.142)
        expect(float).to_not have_value(Math::PI)
      end

      it 'rounds floats correctly' do
        float1 = Dims::Inches.new(1.2346)
        float2 = Dims::Inches.new(1.2344)
        float3 = Dims::Inches.new(1.2345)

        expect(float1).to have_value(1.235)
        expect(float2).to have_value(1.234)
        expect(float3).to have_value(1.235)
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
        expect(float_precision).to     have_value(3.14)
        expect(float_precision).to_not have_value(3.1)
        expect(float_precision).to_not have_value(Math::PI)
      end

      it 'rounds floats correctly' do
        float1 = Dims::Inches.new(1.237, supplied_precision)
        float2 = Dims::Inches.new(1.232, supplied_precision)
        float3 = Dims::Inches.new(1.235, supplied_precision)

        expect(float1).to have_value(1.24)
        expect(float2).to have_value(1.23)
        expect(float3).to have_value(1.24)
      end
    end
  end
end
