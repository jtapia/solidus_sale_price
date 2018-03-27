RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :view
  config.include Rack::Test::Methods, type: :feature
  config.include Devise::Test::ControllerHelpers, type: :controller
end