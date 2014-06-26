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

  it 'defines all the comparison methods' do
    expect(Measurb::Dimension).to have_method(:<=>)
    expect(Measurb::Dimension).to have_method(:<)
    expect(Measurb::Dimension).to have_method(:>)
    expect(Measurb::Dimension).to have_method(:<=)
    expect(Measurb::Dimension).to have_method(:>=)
  end

  it 'handles inequality operations correctly with same class' do
    expect(2.feet).to_not        be <  2.feet
    expect(2.feet).to_not        be >  2.feet
    expect(2.feet).to            be <= 2.feet
    expect(2.feet).to            be >= 2.feet
    expect(2.feet <=> 2.feet).to be(0)

    expect(2.feet).to            be <  3.feet
    expect(2.feet).to            be <= 3.feet
    expect(2.feet).to_not        be >  3.feet
    expect(2.feet).to_not        be >= 3.feet
    expect(2.feet <=> 3.feet).to be(-1)

    expect(3.feet).to_not        be <  2.feet
    expect(3.feet).to_not        be <= 2.feet
    expect(3.feet).to            be >  2.feet
    expect(3.feet).to            be >= 2.feet
    expect(3.feet <=> 2.feet).to be(1)
  end

  it 'handles inequality operations correctly with a different dimension class' do
    expect(2.feet).to_not           be <  24.inches
    expect(2.feet).to_not           be >  24.inches
    expect(2.feet).to               be <= 24.inches
    expect(2.feet).to               be >= 24.inches
    expect(2.feet <=> 24.inches).to be(0)

    expect(2.feet).to            be <  36.inches
    expect(2.feet).to            be <= 36.inches
    expect(2.feet).to_not        be >  36.inches
    expect(2.feet).to_not        be >= 36.inches
    expect(2.feet <=> 36.inches).to be(-1)

    expect(3.feet).to_not        be <  24.inches
    expect(3.feet).to_not        be <= 24.inches
    expect(3.feet).to            be >  24.inches
    expect(3.feet).to            be >= 24.inches
    expect(3.feet <=> 24.inches).to be(1)
  end
end
