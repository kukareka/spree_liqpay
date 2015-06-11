require 'spec_helper'

module Spree
  describe CheckoutController, type: :controller do
    routes { Spree::Core::Engine.routes }

    let(:order) { create :order_with_line_items, state: 'payment' }

    before do
      expect(controller).to receive_messages current_order: order, check_authorization: true
    end

    describe '#liqpay_status' do
      it 'returns false if the order has no completed payments' do
        completed_payments false
        get :liqpay_status, order_id: order
        expect(response).to have_http_status :success
        expect(JSON.parse(response.body)['completed']).to eq false
      end

      it 'returns true if the order has completed payments' do
        completed_payments true
        get :liqpay_status, order_id: order
        expect(response).to have_http_status :success
        expect(JSON.parse(response.body)['completed']).to eq true
      end
    end

    describe '#liqpay_result' do
      render_views

      it 'waits for response from liqpay gateway' do
        completed_payments false
        get :liqpay_result, order_id: order
        expect(response).to have_http_status :success
        expect(response.body).to have_selector '#liqpay_spinner'
      end

      it 'redirects to update action after response from liqpay gateway' do
        completed_payments true
        get :liqpay_result, order_id: order
        expect(response).to have_http_status :redirect
      end
    end

    private

    def completed_payments value
      expect(controller).to receive(:has_completed_payments?).and_return value
    end


  end
end
