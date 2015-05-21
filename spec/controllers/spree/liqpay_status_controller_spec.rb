require 'spec_helper.rb'

module Spree
  describe LiqpayStatusController, type: :controller do
    routes { Spree::Core::Engine.routes }

    let(:liqpay) { create :liqpay }
    let(:order) { create :order_with_line_items }
    let(:data) do
       {
           order_id: order.id,
           currency: order.currency,
           amount: order.total,
           type: 'buy',
           status: 'sandbox'
       }
    end

    it 'needs payment method' do
      expect do
        post :update, payment_method_id: liqpay.id * 100
      end.to raise_error ActiveRecord::RecordNotFound
    end

    it 'checks signature' do
      expect_any_instance_of(Spree::PaymentMethod::Liqpay).to receive(:check_signature).and_return false
      post :update, payment_method_id: liqpay, data: encode_json(data)
      expect(response.status).to eq 401
    end

    context 'with correct signature' do
      before do
        expect_any_instance_of(Spree::PaymentMethod::Liqpay).to receive(:check_signature).and_return true
      end

      it 'needs order' do
        expect do
          post :update, payment_method_id: liqpay, data: encode_json(order_id: order.id * 100)
        end.to raise_error ActiveRecord::RecordNotFound
      end

      context 'order' do
        before do
          create :payment, order: order, state: :completed
        end
        it 'must not have complete payments' do
          expect do
            post :update, payment_method_id: liqpay, data: encode_json(order_id: order.id)
          end.to raise_error ArgumentError
        end
      end

      it 'checks currency' do
        expect do
          post :update, payment_method_id: liqpay, data: encode_json(data.merge currency: 'XXX')
        end.to raise_error ArgumentError
      end

      it 'checks amount' do
        expect do
          post :update, payment_method_id: liqpay, data: encode_json(data.merge amount: (order.total * 2).to_digits)
        end.to raise_error ArgumentError
      end

      it 'checks type' do
        expect do
          post :update, payment_method_id: liqpay, data: encode_json(data.merge type: 'sell')
        end.to raise_error ArgumentError
      end

      it 'checks status' do
        expect do
          post :update, payment_method_id: liqpay, data: encode_json(data.merge status: 'fail')
        end.to raise_error ArgumentError
      end

      it 'does not allow sandbox status without test mode' do
        expect_any_instance_of(Spree::PaymentMethod::Liqpay).to receive(:preferred_test_mode).and_return false
        expect do
          post :update, payment_method_id: liqpay, data: encode_json(data.merge status: 'sandbox')
        end.to raise_error ArgumentError
      end

      it 'allows sandbox status in test mode' do
        expect_any_instance_of(Spree::PaymentMethod::Liqpay).to receive(:preferred_test_mode).and_return true
        post :update, payment_method_id: liqpay, data: encode_json(data.merge status: 'sandbox')
        expect(response).to have_http_status 200
      end

      it 'creates payment' do
        post :update, payment_method_id: liqpay, data: encode_json(data)

        expect(response).to have_http_status 200

        expect(order.payments.count).to eq 1

        payment = order.payments.first

        expect(payment.payment_method).to eq liqpay
        expect(payment.state).to eq 'completed'
        expect(payment.amount).to eq order.total
      end
    end
  end
end
