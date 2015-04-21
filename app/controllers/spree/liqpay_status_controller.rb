module Spree
  class LiqpayStatusController < ApplicationController

    skip_before_filter :verify_authenticity_token

    # callbacks from Liqpay server
    def update
      data = JSON.parse(Base64.strict_decode64(params[:data]))
      @payment_method = PaymentMethod.find(params[:payment_method_id])
      render text: "Bad signature\n", status: 401 and return unless @payment_method.check_signature(params[:data], params[:signature])
      @order = Order.find(data['order_id'])

      raise ArgumentError unless @order.payments.completed.empty? &&
        data['currency'] == @order.currency &&
        BigDecimal.new(data['amount']) == @order.total &&
        data['type'] == 'buy' &&
        (data['status'] == 'success' || (@payment_method.preferred_test_mode && data['status'] == 'sandbox'))

      payment = @order.payments.create(amount: @order.total, payment_method: @payment_method)
      payment.complete!

      render text: "Thank you.\n"
    end
  end
end