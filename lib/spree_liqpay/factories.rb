FactoryGirl.define do
  factory :liqpay, class: Spree::PaymentMethod::Liqpay do
    name 'Liqpay'
  end
end
