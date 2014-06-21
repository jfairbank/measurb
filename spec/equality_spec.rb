require 'spec_helper'

describe Dims::Dimension do
  before :context do
    clear_defined_inches
    clear_defined_feet
    remove_loaded_default_dimensions

    Dims.configure do |config|
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
end
