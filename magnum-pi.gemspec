# -*- encoding: utf-8 -*-
require File.expand_path("../lib/magnum-pi/version", __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Paul Engel"]
  gem.email         = ["pm_engel@icloud.com"]
  gem.summary       = %q{Create an easy interface to talk with APIs}
  gem.description   = %q{Create an easy interface to talk with APIs}
  gem.homepage      = "https://github.com/archan937/magnum-pi"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "magnum-pi"
  gem.require_paths = ["lib"]
  gem.version       = MagnumPI::VERSION

  gem.add_dependency "mechanize"
  gem.add_dependency "oj"
  gem.add_dependency "xml-simple"

  gem.add_development_dependency "rake"
  gem.add_development_dependency "pry"
  gem.add_development_dependency "simplecov"
  gem.add_development_dependency "minitest"
  gem.add_development_dependency "mocha"
end