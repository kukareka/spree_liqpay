FactoryGirl.define do
  factory :liqpay, class: Spree::PaymentMethod::Liqpay do
    name 'Liqpay'
    preferred_server 'http://localhost/'
    preferred_private_key SecureRandom.hex 16
    preferred_public_key  SecureRandom.hex 8
    active true
  end
end
