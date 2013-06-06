# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'botscout/version'

Gem::Specification.new do |spec|
  spec.name          = "botscout"
  spec.version       = Botscout::VERSION
  spec.authors       = ["Maxim Pechnikov"]
  spec.email         = ["parallel588@gmail.com"]
  spec.description   = %q{BotScout}
  spec.summary       = %q{Ruby bindings for the botscout.com API}
  spec.homepage      = "http://botscout.com/"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_dependency "httparty", "~> 0.11.0"
end
