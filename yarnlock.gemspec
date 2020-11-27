# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yarnlock/version'

Gem::Specification.new do |spec|
  spec.name          = 'yarnlock'
  spec.version       = Yarnlock::VERSION
  spec.authors       = ['Hiroki Shimizu']
  spec.email         = ['elsewhere2424@gmail.com']

  spec.summary       = 'Thin wrapper of @yarnpkg/lockfile for Ruby'
  spec.description   = 'Yarnlock provides to parse/stringify yarn.lock file for Ruby'
  spec.homepage      = 'https://github.com/hiromi2424/ruby-yarnlock'
  spec.license       = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.4'

  spec.add_dependency 'semantic', '~> 1.6'

  spec.add_development_dependency 'bundler', '~> 2.1'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.10'
  spec.add_development_dependency 'rubocop', '~> 1.4'
end
