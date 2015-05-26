$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "spree_liqpay/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "spree_liqpay"
  s.version     = SpreeLiqpay::VERSION
  s.authors     = ["Oleg Kukareka"]
  s.email       = ["oleg@kukareka.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of SpreeLiqpay."
  s.description = "TODO: Description of SpreeLiqpay."
  s.license     = "MIT"
  s.required_ruby_version = '>= 1.9'

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_runtime_dependency 'spree_core', '~> 3.0.0'
  s.add_runtime_dependency 'spree_frontend', '~> 3.0.0'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'coffee-script'
end
