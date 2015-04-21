module Spree
  class BillingIntegration::Liqpay < BillingIntegration
    preference :server, :string, default: 'https://www.liqpay.com'
    preference :public_key, :string
    preference :private_key, :string
    preference :order_description, :string, default: -> {Spree::Store.current.name}

    def provider_class
      ActiveMerchant::Billing::Liqpay
    end

    def source_required?
      false
    end

    def checkout_url
      "#{preferred_server}/api/checkout"
    end

    def cnb_form_fields(order, result_url, server_url)
      provider_class.new(preferred_public_key, preferred_private_key).cnb_form_fields amount: order.total,
                                                                  currency: order.currency,
                                                                  description: preferred_order_description,
                                                                  order_id: order.id,
                                                                  result_url: result_url,
                                                                  server_url: server_url,
                                                                  sandbox: preferred_test_mode ? 1 : 0
    end

    def check_signature(data, signature)
      provider_class.new(preferred_public_key, preferred_private_key).check_signature(data, signature)
    end


=begin
    def provider_class
      ::PayPal::SDK::Merchant::API
    end

    def provider
      ::PayPal::SDK.configure(
          :mode      => preferred_server.present? ? preferred_server : "sandbox",
          :username  => preferred_login,
          :password  => preferred_password,
          :signature => preferred_signature)
      provider_class.new
    end


    def purchase(amount, express_checkout, gateway_options={})
      pp_details_request = provider.build_get_express_checkout_details({
                                                                           :Token => express_checkout.token
                                                                       })
      pp_details_response = provider.get_express_checkout_details(pp_details_request)

      pp_request = provider.build_do_express_checkout_payment({
                                                                  :DoExpressCheckoutPaymentRequestDetails => {
                                                                      :PaymentAction => "Sale",
                                                                      :Token => express_checkout.token,
                                                                      :PayerID => express_checkout.payer_id,
                                                                      :PaymentDetails => pp_details_response.get_express_checkout_details_response_details.PaymentDetails
                                                                  }
                                                              })

      pp_response = provider.do_express_checkout_payment(pp_request)
      if pp_response.success?
        # We need to store the transaction id for the future.
        # This is mainly so we can use it later on to refund the payment if the user wishes.
        transaction_id = pp_response.do_express_checkout_payment_response_details.payment_info.first.transaction_id
        express_checkout.update_column(:transaction_id, transaction_id)
        # This is rather hackish, required for payment/processing handle_response code.
        Class.new do
          def success?; true; end
          def authorization; nil; end
        end.new
      else
        class << pp_response
          def to_s
            errors.map(&:long_message).join(" ")
          end
        end
        pp_response
      end
    end
=end
  end
end
