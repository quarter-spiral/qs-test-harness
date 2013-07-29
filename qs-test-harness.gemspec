# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'qs-test-harness/version'

Gem::Specification.new do |gem|
  gem.name          = "qs-test-harness"
  gem.version       = Qs::Test::Harness::VERSION
  gem.authors       = ["Thorben Schröder"]
  gem.email         = ["thorben@quarterspiral.com"]
  gem.description   = %q{Test harness for QS projects}
  gem.summary       = %q{Test harness for QS projects}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'rake'

  gem.add_dependency 'rack-test'

  gem.add_dependency 'service-client', '>= 0.0.13'

  gem.add_dependency 'graph-backend', '>= 0.0.28'
  gem.add_dependency 'graph-client', '>= 0.0.12'

  gem.add_dependency 'datastore-backend', '>= 0.0.20'
  gem.add_dependency 'datastore-client', '>= 0.0.11'

  gem.add_dependency 'playercenter-backend', '>= 0.0.32'
  gem.add_dependency 'playercenter-client', '>= 0.0.4'

  gem.add_dependency 'devcenter-backend', '>= 0.0.54'
  gem.add_dependency 'devcenter-client', '>= 0.0.4'

  gem.add_dependency 'rack-client'
  gem.add_dependency 'uuid'

  # gem.add_dependency 'auth-backend', "~> 0.0.45"
  gem.add_dependency 'auth-client', '0.0.16'
  gem.add_dependency 'sqlite3'
  gem.add_dependency 'sinatra_warden', '0.3.2.qs2'
  gem.add_dependency 'songkick-oauth2-provider', '0.10.2.qs1'
  gem.add_dependency 'nokogiri'
  gem.add_dependency 'padrino-core', '>= 0.11.2'
end