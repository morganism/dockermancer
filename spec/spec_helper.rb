require "rspec"
require "mocha/api"
require "aruba/rspec"

RSpec.configure do |config|
  config.color = true
  config.formatter = :documentation
  config.mock_with :mocha
  config.include Aruba::Api
end
