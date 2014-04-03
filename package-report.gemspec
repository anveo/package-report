# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'package_report/version'

Gem::Specification.new do |spec|
  spec.name          = "package-report"
  spec.version       = PackageReport::VERSION
  spec.authors       = ["Brian Racer"]
  spec.email         = ["bracer@gmail.com"]
  spec.summary       = %q{Analyze package upgrade options on debian based systems.}
  spec.homepage      = "https://github.com/anveo/package-report"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activesupport", "3.2.15"
  spec.add_runtime_dependency "fog", ["= 1.21.0"]
  spec.add_runtime_dependency "unf", ["= 0.1.3"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "guard", "2.6.0"
  spec.add_development_dependency "guard-rspec", "4.2.8"
  spec.add_development_dependency "rspec", "2.14.1"
end
