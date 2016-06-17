# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "omniauth-myvr"
  s.version     = "0.0.1"
  s.authors     = ["CJ Avilla"]
  s.email       = ["cjavilla@gmail.com"]
  s.homepage    = "https://github.com/w1zeman1p/omniauth-myvr"
  s.description = %q{OmniAuth strategy for MyVR}
  s.summary     = s.description
  s.license     = "MIT"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'omniauth', '>= 1.1.1'
  s.add_dependency 'omniauth-oauth2', '>= 1.3.1'
  s.add_development_dependency 'bundler', '~> 1.0'
end
