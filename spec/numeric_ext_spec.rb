require 'spec_helper'

describe Numeric do
  describe '#inches' do
    before :context do
      clear_defined_inches
      Dims.define(:inches)
    end

    shared_context 'returning expected' do |n|
      it 'returns the dimension class instance' do
        expect(n.inches).to be_a(Dims::Inches)
        expect(n.inches).to eq(Dims::Inches.new(n))
      end
    end

    context 'with integer value' do
      include_context 'returning expected', 42
    end

    context 'with float value' do
      include_context 'returning expected', 3.14
    end
  end
end
