# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'meta_hari/version'

Gem::Specification.new do |spec|
  spec.name          = 'meta_hari'
  spec.version       = MetaHari::VERSION
  spec.authors       = ['Paul Spieker']
  spec.email         = ['p.spieker@duenos.de']
  spec.summary       = %q{Receiving product informations from a given link.}
  spec.homepage      = 'https://github.com/spieker/meta_hari'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'microdata', '~> 0.0.3'
  spec.add_dependency 'addressable', '~> 2.3.8'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.2.0'
  spec.add_development_dependency 'guard', '~> 2.12.5'
  spec.add_development_dependency 'guard-rspec', '~> 4.5.0'
  spec.add_development_dependency 'rubocop', '~> 0.31.0'
  spec.add_development_dependency 'guard-rubocop', '~> 1.2.0'
  spec.add_development_dependency 'pry', '~> 0.10.1'
  spec.add_development_dependency 'nokogiri', '~> 1.6.6'
end
