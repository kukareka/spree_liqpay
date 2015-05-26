# Configure Rails Environment
ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../dummy/config/environment.rb',  __FILE__)
require 'rspec/rails'
require 'capybara/rails'
require 'factory_girl_rails'
require 'database_cleaner'
require 'ffaker'

StateMachines::Machine.ignore_method_conflicts = true

require 'spree/testing_support/url_helpers'
require 'spree/testing_support/controller_requests'
require 'spree/testing_support/factories'
require 'spree_liqpay/factories'

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

FactoryGirl::SyntaxRunner.send :include, Spree::TestingSupport::UrlHelpers

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include Spree::TestingSupport::UrlHelpers

  config.include Faker::Name
  config.include Faker::Internet
  config.include Faker::AddressUS
  config.include Faker::PhoneNumber

  config.mock_with :rspec
  config.color = true
  config.use_transactional_fixtures = false

  Capybara.ignore_hidden_elements = false

  config.before :suite do
    DatabaseCleaner.clean_with :truncation
  end

  config.before :each do |example|
    DatabaseCleaner.strategy = example.metadata[:js] ? :truncation : :transaction
    DatabaseCleaner.start
  end

  config.after :each do |example|
    Capybara.reset_sessions! if example.metadata[:js]
    DatabaseCleaner.clean
  end
end
