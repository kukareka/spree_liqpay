module Spree
  CheckoutController.class_eval do
    def liqpay_result
      update if has_completed_payments?
    end

    def liqpay_status
      render json: {completed: has_completed_payments?}
    end

    private

    def has_completed_payments?
      @order.payments.completed.any?
    end
  end
end