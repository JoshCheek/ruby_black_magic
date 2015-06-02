# -*- encoding: utf-8 -*-
# $:.push File.expand_path("../lib", __FILE__)
# require "surrogate/version"

Gem::Specification.new do |s|
  s.name        = "object_model"
  s.version     = '0.0.0'
  s.authors     = ["Josh Cheek"]
  s.email       = ["josh.cheek@gmail.com"]
  s.homepage    = "https://github.com/JoshCheek/"
  s.summary     = %q{Object Model!}
  s.description = %q{Object Model!}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  # s.require_paths = ["lib"]


  # should be dev dep?
  s.add_development_dependency "rake-compiler"

  s.add_development_dependency "rake"
  s.add_development_dependency "mrspec"
end
