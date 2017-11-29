# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'inline_fixtures/version'

Gem::Specification.new do |gem|
  gem.name          = "inline_fixtures"
  gem.version       = InlineFixtures::VERSION
  gem.authors       = ["Jason Edwards"]
  gem.email         = ["jtanium@gmail.com"]
  gem.description   = %q{Fast inline fixtures}
  gem.summary       = %q{Don't use external fixture files}
  gem.homepage      = "https://github.com/jtanium/inline_fixtures"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency "rspec"
  gem.add_runtime_dependency "activerecord", ">= 5"

  gem.add_development_dependency "rspec"

  gem.required_ruby_version = ">= 2.2.2"
end
