# -*- encoding: utf-8 -*-
# $:.push File.expand_path("../lib", __FILE__)
# require "surrogate/version"

Gem::Specification.new do |s|
  s.name        = "fucking-around"
  s.version     = '0.0.0'
  s.authors     = ["Josh Cheek"]
  s.email       = ["josh.cheek@gmail.com"]
  s.homepage    = "http://www.google.com"
  s.summary     = %q{Fucking around.}
  s.description = %q{Fucking around.}

  s.rubyforge_project = "fucking-around"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  # s.require_paths = ["lib"]
  s.extensions << "ext/faye_websocket/extconf.rb"


  # should be dev dep?
  s.add_development_dependency "rake-compiler"

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec", "~> 2.4"
end
