$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'spree_liqpay/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'spree_liqpay'
  s.version     = SpreeLiqpay::VERSION
  s.authors     = ['Oleg Kukareka']
  s.email       = ['oleg@kukareka.com']
  s.homepage    = 'https://github.com/kukareka/spree_liqpay'
  s.summary     = 'Payment Method for Liqpay.com.'
  s.description = 'Liqpay.com payment gateway integration for Spree E-Commerce.'
  s.license     = 'MIT'
  s.required_ruby_version = '>= 1.9'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['spec/**/*']

  s.add_runtime_dependency 'spree_core', '~> 3.0'
  s.add_runtime_dependency 'spree_frontend', '~> 3.0'

  s.add_development_dependency 'sqlite3', '~> 1.3'
  s.add_development_dependency 'rspec-rails', '~> 3.2'
  s.add_development_dependency 'capybara', '~> 2.4'
  s.add_development_dependency 'factory_girl_rails', '~> 4.5'
  s.add_development_dependency 'database_cleaner', '~> 1.4'
  s.add_development_dependency 'ffaker', '~> 1.16'
  s.add_development_dependency 'selenium-webdriver', '~> 2.45'
  s.add_development_dependency 'coffee-script', '~> 2.4'
end
