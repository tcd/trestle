$LOAD_PATH.push File.expand_path("lib", __dir__)
require "trestle/version"

Gem::Specification.new do |spec|
  spec.name          = "trestle"
  spec.version       = Trestle::VERSION

  spec.authors       = ["Sam Pohlenz"]
  spec.email         = ["sam@sampohlenz.com"]

  spec.summary       = "A modern, responsive admin framework for Ruby on Rails"
  spec.description   = "Trestle is a modern, responsive admin framework for Ruby on Rails."
  spec.homepage      = "https://www.trestle.io"
  spec.license       = "LGPL-3.0"

  to_reject          = %r{^(bin|coverage|gemfiles|node_modules|spec|sandbox|.yardoc|ignore)/}
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(to_reject) }

  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.2.2"

  spec.add_dependency "activemodel",     ">= 4.2.0"
  spec.add_dependency "kaminari",        ">= 1.1.0"
  spec.add_dependency "railties",        ">= 4.2.0"
  spec.add_dependency "sprockets-rails", ">= 2.0.0"

  spec.add_development_dependency "ammeter",             "~> 1.1.4"
  spec.add_development_dependency "database_cleaner",    "~> 1.8.3"
  spec.add_development_dependency "rspec-html-matchers", "~> 0.9.2"
  spec.add_development_dependency "rspec-rails",         "~> 3.5"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "sqlite3", "~> 1.3.6"
  spec.add_development_dependency "turbolinks"

  spec.add_development_dependency "inch", "~> 0.8.0" # Documentation coverage reporting
  spec.add_development_dependency "redcarpet", "~> 3.5" # Markdown parser for YARD
  spec.add_development_dependency "yard", "~> 0.9.26" # Ruby documentation generator
  spec.add_development_dependency "yard-junk", "~> 0.0.9" # Structured error logging for YARD
end
