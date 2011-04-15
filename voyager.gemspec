# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "voyager/version"

Gem::Specification.new do |s|
  s.name        = "voyager"
  s.version     = Voyager::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Brice Stacey"]
  s.email       = ["bricestacey@gmail.com"]
  s.homepage    = "https://github.com/bricestacey/voyager"
  s.summary     = %q{ActiveRecord bindings for Voyager ILS}
  s.description = %q{ActiveRecord bindings for Voyager ILS}

  s.rubyforge_project = "voyager"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('activerecord')
  s.add_dependency('activerecord-oracle_enhanced-adapter')
  s.add_dependency('ruby-oci8')
end
