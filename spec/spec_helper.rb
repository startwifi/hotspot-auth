require_relative '../config/environment'
require 'rack/test'
require 'rspec'
require 'faker'
require 'factory_girl'
require 'omniauth/test'
require 'database_cleaner'
require 'shoulda/matchers'
require 'sinatra'

ENV['SINATRA_ENV'] = 'test'

Dir[File.join(settings.root, '../spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Base.logger = nil
OmniAuth.config.test_mode = true

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.include Rack::Test::Methods
  config.include Shoulda::Matchers::ActiveModel, type: :model
  config.include Shoulda::Matchers::ActiveRecord, type: :model

  # FactoryGirl Methods
  config.include FactoryGirl::Syntax::Methods

  # Omniauth helpers
  config.include Omniauth::Mock

  # DatabaseCleaner policy
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

def app
  Rack::Builder.parse_file('config.ru').first
end
