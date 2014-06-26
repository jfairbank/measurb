require 'spec_helper'

describe Measurb::Dimension do
  before :context do
    clear_defined_inches
    clear_defined_feet
    remove_loaded_default_dimensions

    Measurb.configure do |config|
      config.enable_defaults :inches, :feet
    end
  end

  describe '#==' do
    it 'handles equality with itself correctly' do
      n = 42.inches
      expect(n).to eq(n)
      expect(n).to be(n)
    end

    it 'handles equality with same dimension class correctly' do
      x, y = 42.inches, 42.inches

      expect(x).to     eq(y)
      expect(x).to_not be(y)
      expect(x).to_not eq(24.inches)
    end

    it 'handles equality with another dimension class correctly' do
      expect(24.inches).to    eq(2.feet)
      expect(2.inches).to_not eq(24.feet)
    end
  end

  describe '#!=' do
    it 'handles inequality with itself correctly' do
      n = 42.inches
      expect(n != n).to be(false)
      expect(n).to      be(n)
    end

    it 'handles inequality with same dimension class correctly' do
      x = 42.inches
      expect(x != 42.inches).to be(false)
      expect(x != 24.inches).to be(true)
    end

    it 'handles inequality with another dimension class correctly' do
      expect(24.inches != 2.feet).to  be(false)
      expect(2.inches  != 24.feet).to be(true)
    end
  end

  describe '#eql?' do
    it 'recognizes equality with itself' do
      n = 42.inches
      expect(n).to eql(n)
      expect(n).to be(n)
    end

    it 'recognizes equality only with dimensions of the same class and value' do
      n = 24.inches

      expect(n).to     eql(24.inches)
      expect(n).to_not eql(2.feet)
      expect(n).to_not eql(3.feet)
      expect(n).to_not eql(36.inches)
    end
  end
end
