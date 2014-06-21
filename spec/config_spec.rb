require 'spec_helper'
require 'rspec/expectations'

describe Dims do
  describe '.config' do
    subject { Dims.config }

    it { should be_a Dims::Config }

    describe '.enable_defaults' do
      before :example do
        clear_defined_inches
        clear_defined_feet
        clear_defined_yards
        remove_loaded_default_dimensions
      end

      let :dims_dimensions do
        Dims.constants.reduce([]) do |array, constant_name|
          constant = Dims.const_get(constant_name)
          array << constant if constant.is_a?(Class) && constant < Dims::Dimension
          array
        end
      end

      context 'without arguments' do
        it "doesn't add any dimensions" do
          subject.enable_defaults
          expect(dims_dimensions).to be_empty
        end
      end

      context 'with one argument' do
        it 'only adds the one dimension' do
          subject.enable_defaults :inches
          expect(dims_dimensions).to match_array [Dims::Inches]
        end
      end

      context 'with more than one argument' do
        it 'only adds the given dimensions' do
          subject.enable_defaults :inches, :feet
          expect(dims_dimensions).to match_array [Dims::Inches, Dims::Feet]
        end
      end
    end
  end
end
