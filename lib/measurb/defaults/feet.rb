Measurb.define :feet, abbrev: 'ft' do
  inches value * 12.0
  yards  value / 3.0
end
