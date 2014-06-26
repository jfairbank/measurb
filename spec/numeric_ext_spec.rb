require 'spec_helper'

describe Numeric do
  describe '#inches' do
    before :context do
      clear_defined_inches
      Measurb.define(:inches)
    end

    shared_context 'returning expected' do |n|
      it 'returns the dimension class instance' do
        expect(n.inches).to be_a(Measurb::Inches)
        expect(n.inches).to eq(Measurb::Inches.new(n))
      end
    end

    shared_context 'having correct precision' do |n|
      it 'sets default precision without an argument' do
        expect(n.inches).to have_precision(Measurb::DEFAULT_PRECISION)
      end

      it 'sets the supplied precision' do
        expect(n.inches(2)).to have_precision(2)
      end
    end

    context 'with integer value' do
      n = 42

      include_context 'returning expected', n
      include_context 'having correct precision', n
    end

    context 'with float value' do
      n = Math::PI

      include_context 'returning expected', n
      include_context 'having correct precision', n
    end
  end
end
