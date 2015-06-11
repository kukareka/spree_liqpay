require 'spree_core'

module SpreeLiqpay
  class Engine < ::Rails::Engine
    isolate_namespace Spree
    engine_name 'spree_liqpay'

    config.autoload_paths += %W(#{config.root}/lib)

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec, fixture: false
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
      g.assets false
      g.helper false
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    config.to_prepare &method(:activate).to_proc

    initializer 'spree.liqpay.payment_methods', after: 'spree.register.payment_methods' do |app|
      app.config.spree.payment_methods << ::Spree::PaymentMethod::Liqpay
    end

  end
end
