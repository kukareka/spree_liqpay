# Configure Rails Environment
ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../dummy/config/environment.rb',  __FILE__)
require 'rspec/rails'
require 'capybara/rails'
require 'factory_girl_rails'
require 'database_cleaner'
require 'ffaker'

StateMachines::Machine.ignore_method_conflicts = true

require 'spree/testing_support/factories'

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.mock_with :rspec
  config.color = true
  config.use_transactional_fixtures = false

  DatabaseCleaner.clean_with :truncation
  DatabaseCleaner.strategy = :transaction

  config.after do
    DatabaseCleaner.clean
  end
end
