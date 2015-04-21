module Spree
  CheckoutController.class_eval do
    def liqpay_result
      update if @order.payments.completed.any?
    end

    def liqpay_status
      render json: {completed: @order.payments.completed.any?}
    end
  end
end