# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "liquid-proxy/version"

Gem::Specification.new do |s|
  s.name        = "liquid-proxy"
  s.version     = LiquidProxy::VERSION
  s.authors     = ["artemave"]
  s.email       = ["artemave@gmail.com"]
  s.homepage    = "https://github.com/artemave/liquid-proxy"
  s.summary     = %q{http proxy with api for modifying requests passing through}
  #s.description = %q{http proxy with api for modifying requests passing through}

  s.rubyforge_project = "liquid-proxy"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_runtime_dependency "em-proxy"
  s.add_runtime_dependency "http_tools"
  s.add_runtime_dependency "http_parser.rb"
  s.add_runtime_dependency 'childprocess'
end
