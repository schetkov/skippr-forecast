require 'factory_girl_rails'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  # config.before(:suite) do
  #   FactoryGirl.lint
  # end
end
