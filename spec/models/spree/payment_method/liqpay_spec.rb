require 'spec_helper.rb'

module Spree
  describe PaymentMethod::Liqpay do
    let(:store) { Spree::Store.current }

    before do
      create :store, name: 'Test store'
    end

    let :payment_method do
      create :liqpay
    end

    it 'has server' do
      expect(payment_method.preferred_server).not_to be_nil
    end

    it 'has public key' do
      expect(payment_method.preferred_public_key).not_to be_nil
    end

    it 'has private key' do
      expect(payment_method.preferred_private_key).not_to be_nil
    end

    it 'has order description' do
      expect(payment_method.preferred_order_description).not_to be_nil
      expect(payment_method.preferred_order_description).to eq store.name
    end

    it 'is in test mode' do
      expect(payment_method.preferred_test_mode).to eq true
    end

    describe '#cnb_form_fields' do
      let(:order) {create :order}

      let(:result_url) {'http://example.com/result_url'}
      let(:server_url) {'http://example.com/server_url'}

      let :provider do
        provider = double 'Provider'
        allow(payment_method).to receive(:provider) { provider }
        provider
      end

      let :response do
        {
            data: 'data',
            signature: 'signature'
        }
      end

      let :form_fields do
        {
            amount: order.total,
            currency: order.currency,
            description: payment_method.preferred_order_description,
            order_id: order.id,
            result_url: result_url,
            server_url: server_url,
            sandbox: 1
        }
      end

      it 'returns provider cnb form fields' do
        expect(provider).to receive(:cnb_form_fields).with(form_fields).and_return response
        expect(payment_method.cnb_form_fields order, result_url, server_url).to eq response
      end
    end
  end
end