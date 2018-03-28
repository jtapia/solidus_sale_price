# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)

require 'solidus_sale_price/version'

# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'solidus_sale_price'
  s.version     = SolidusSalePrice::VERSION
  s.summary     = 'Sale price for Solidus'
  s.description = 'Solidus extension to set sale products with start and end date.'
  s.required_ruby_version = '>= 2.1'

  s.author    = 'Jonathan Tapia'
  s.email     = 'jonathan.tapia@magmalabs.io'

  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.has_rdoc = false

  s.add_dependency 'solidus', ['>= 1.0', '< 3']
  s.add_dependency 'solidus_support'
  s.add_dependency 'deface', '~> 1.0'

  s.add_development_dependency 'rspec-rails','~> 3.1'
  s.add_development_dependency 'rspec-activemodel-mocks'
  s.add_development_dependency 'sqlite3', '~> 1.3'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'factory_bot', '~> 4.5'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'capybara', '~> 2.5'
  s.add_development_dependency 'database_cleaner', '~> 1.4'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'pry-rails', '>= 0.3.0'
  s.add_development_dependency 'byebug'
  s.add_development_dependency 'simplecov', '~> 0.9'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'poltergeist'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'timecop', '~> 0.9'
  s.add_development_dependency 'i18n-spec', '>= 0.5.0'
  s.add_development_dependency 'rubocop', '>= 0.24.1'
end
