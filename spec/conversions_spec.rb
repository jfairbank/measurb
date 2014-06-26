require 'spec_helper'

describe Measurb do
  describe '.define' do
    shared_context 'defines own conversion' do |with_abbrev = false|
      it 'defines own conversion' do
        expect(Measurb::Inches).to have_method(:to_inches)
      end

      it 'returns itself' do
        n = 42.inches
        expect(n.to_inches).to be(n)
      end
    end

    context 'without define block' do
      before :example do
        clear_defined_inches
        Measurb.define(:inches)
      end

      include_context 'defines own conversion'

      it "doesn't have other conversions" do
        expect(Measurb::Inches).to_not have_method(:to_feet)
      end
    end

    context 'with define block' do
      before :example do
        clear_defined_inches
        clear_defined_feet

        Measurb.define(:inches) { feet value / 12.0 }
        Measurb.define(:feet)
      end

      include_context 'defines own conversion'

      it 'adds the `to_feet` conversion' do
        expect(Measurb::Inches).to have_method(:to_feet)
      end

      it 'returns an instance of `Measurb::Feet` with the correct value' do
        n = 24.inches

        expect(n.to_feet).to be_a(Measurb::Feet)
        expect(n.to_feet).to eq(2.feet)
      end
    end
  end
end
