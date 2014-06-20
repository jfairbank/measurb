Dims.define :feet, abbrev: 'ft' do
  inches value * factor(12.0)
  yards  value / factor(3.0)
end
