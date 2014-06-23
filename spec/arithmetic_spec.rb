require 'spec_helper'

describe Dims::Dimension do
  before :context do
    clear_defined_inches
    clear_defined_feet
    clear_defined_yards
    remove_loaded_default_dimensions

    Dims.configure do |config|
      config.enable_defaults :inches, :feet
    end
  end

  let(:inches) { 24.inches }
  let(:feet)   { 5.feet }

  context 'when adding' do
    it 'returns the left hand side class' do
      expect(inches + inches).to be_a(Dims::Inches)
      expect(inches + feet).to   be_a(Dims::Inches)
      expect(feet   + feet).to   be_a(Dims::Feet)
      expect(feet   + inches).to be_a(Dims::Feet)
    end

    it 'adds correctly' do
      expect(inches + inches).to have_value(48)
      expect(inches + feet).to   have_value(84)
      expect(feet   + feet).to   have_value(10)
      expect(feet   + inches).to have_value(7)
    end

    it 'respects the smallest precision' do
      x = Math::PI.inches(4)
      y = 2.001.inches(3)
      sum = x + y

      expect(sum).to have_precision(3)
      expect(sum).to have_value(5.143)
    end
  end

  context 'when subtracting' do
    it 'returns the left hand side class' do
      expect(inches - inches).to be_a(Dims::Inches)
      expect(inches - feet).to   be_a(Dims::Inches)
      expect(feet   - feet).to   be_a(Dims::Feet)
      expect(feet   - inches).to be_a(Dims::Feet)
    end

    it 'subtracts correctly' do
      expect(inches - inches).to have_value(0)
      expect(inches - feet).to   have_value(-36)
      expect(feet   - feet).to   have_value(0)
      expect(feet   - inches).to have_value(3)
    end

    it 'respects the smallest precision' do
      x = Math::PI.inches(4)
      y = 2.001.inches(3)
      difference = x - y

      expect(difference).to have_precision(3)
      expect(difference).to have_value(1.141)
    end
  end
end
