require 'capybara/rspec'
require 'capybara/rails'
require 'capybara/poltergeist'
# require 'capybara-screenshot/rspec'
require 'selenium-webdriver'

RSpec.configure do |config|
  config.include Rack::Test::Methods, type: :requests

  Capybara.javascript_driver = :selenium_chrome_headless
  # Capybara.javascript_driver = :poltergeist
  # Capybara.register_driver :poltergeist do |app|
  #   options = { timeout: 1.minute,
  #               window_size: [1920, 6000],
  #               phantomjs_options: ['--load-images=no', '--disk-cache=false'] }
  #   Capybara::Poltergeist::Driver.new(app, options)
  # end
end