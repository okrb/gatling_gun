# -*- encoding: utf-8 -*-
require File.expand_path('../lib/gatling_gun/version', __FILE__)

SPEC = Gem::Specification.new do |gem|
  gem.name        = "gatling_gun"
  gem.version     = GatlingGun::VERSION
  gem.platform    = Gem::Platform::RUBY
  gem.authors     = ["James Edward Gray II"]
  gem.email       = ["james@graysoftinc.com"]
  gem.homepage    = "https://github.com/okrb/gatling_gun"
  gem.summary     = "A Ruby library wrapping SendGrid's Newsletter API."
  gem.description = <<-END_DESCRIPTION.gsub(/\s+/, " ").strip
  A library for working with SendGrid's Newsletter API.  The code is intended
  for managing and sending newletters.
  END_DESCRIPTION

  gem.required_ruby_version     = ">= 1.8.7"
  gem.required_rubygems_version = ">= 1.3.7"

  gem.add_dependency 'json'

  gem.files         = `git ls-files`.split("\n")
  gem.require_paths = %w[lib]
end
