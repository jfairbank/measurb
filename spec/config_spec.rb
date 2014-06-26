require 'spec_helper'
require 'rspec/expectations'

describe Measurb do
  describe '.config' do
    def get_config
      Measurb.__send__(:config)
    end

    subject { get_config }

    it { should be_a Measurb::Config }

    describe '.enable_defaults' do
      before :example do
        clear_defined_inches
        clear_defined_feet
        clear_defined_yards
        remove_loaded_default_dimensions
      end

      let :dims_dimensions do
        Measurb.constants.reduce([]) do |array, constant_name|
          constant = Measurb.const_get(constant_name)
          array << constant if constant.is_a?(Class) && constant < Measurb::Dimension
          array
        end
      end

      context 'without arguments' do
        subject { get_config.enable_defaults }

        it "doesn't add any dimensions" do
          subject
          expect(dims_dimensions).to be_empty
        end

        it 'returns an empty array' do
          expect(subject).to be_empty
        end
      end

      context 'with one argument' do
        subject { get_config.enable_defaults(:inches) }

        it 'only adds the one dimension' do
          subject
          expect(dims_dimensions).to match_array [Measurb::Inches]
        end

        it 'returns the enabled dimension name in an array' do
          expect(subject).to match_array [:inches]
        end
      end

      context 'with more than one argument' do
        subject { get_config.enable_defaults(:inches, :feet) }

        it 'only adds the given dimensions' do
          subject
          expect(dims_dimensions).to match_array [Measurb::Inches, Measurb::Feet]
        end

        it 'returns the enabled dimension names in an array' do
          expect(subject).to match_array [:inches, :feet]
        end
      end

      context 'with fake default dimension name arguments' do
        subject { get_config.enable_defaults(:inches, :miles, :feet, :leagues) }

        it 'only adds the available default dimensions' do
          subject
          expect(dims_dimensions).to match_array [Measurb::Inches, Measurb::Feet]
        end

        it 'returns only the enabled available dimension names in an array' do
          expect(subject).to match_array [:inches, :feet]
        end

        it 'outputs a warning for each unavailable default dimension name' do
          expectation = "'miles' is not a default dimension\n" <<
                        "'leagues' is not a default dimension\n"

          expect { subject }.to output(expectation).to_stderr
        end
      end
    end
  end
end
