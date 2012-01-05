# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rack/maintenance_mode/version"

Gem::Specification.new do |s|
  s.name        = "rack-maintenance_mode"
  s.version     = Rack::MaintenanceMode::VERSION
  s.authors     = ["Nathaniel Bibler"]
  s.email       = ["git@nathanielbibler.com"]
  s.homepage    = ""
  s.summary     = %q{Manage maintenance mode for your application}
  s.description = %q{Allows you to create a customized maintenance mode for your application that is run early in the Rack stack.}

  s.rubyforge_project = "maintenance_mode"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec"
  s.add_runtime_dependency "rack"
end
