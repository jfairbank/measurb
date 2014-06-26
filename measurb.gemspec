# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'measurb/version'

Gem::Specification.new do |spec|
  spec.name          = 'measurb'
  spec.version       = Measurb::VERSION
  spec.authors       = ['Jeremy Fairbank']
  spec.email         = ['elpapapollo@gmail.com']
  spec.summary       = %q{Handle units of measurement}
  spec.description   = %q{Handle units of measurement}
  spec.homepage      = ''
  spec.license       = 'MIT'

  #spec.files         = `git ls-files -z`.split('\x0')
  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec',   '~> 3.0.0'
end
