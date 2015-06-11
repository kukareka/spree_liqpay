require 'spec_helper.rb'

module ActiveMerchant::Billing
  describe Liqpay do
    let(:public_key) { 'public key' }
    let(:private_key) { 'private key' }

    let :liqpay do
       Liqpay.new public_key, private_key
    end

    let(:length) { 128 }

    let(:data) do
      {
          key1: SecureRandom.hex(length),
          key2: SecureRandom.hex(length),
          key3: SecureRandom.hex(length)
      }.stringify_keys
    end

    let(:json_data) do
      JSON.generate data
    end

    describe '#encode64' do

      let(:encoded_data) { liqpay.encode64 json_data }
      let(:decoded_data) { Base64.strict_decode64 encoded_data }

      it 'encodes string to base64 in strict mode' do
        expect(decoded_data).to eq json_data
      end
    end

    describe '#encode_json' do

      let(:encoded_data) { liqpay.encode_json data }
      let(:decoded_data) { JSON.parse encoded_data }

      it 'encodes string to base64 in strict mode' do
        expect(decoded_data).to eq data
      end
    end

    describe '#encode_signature' do

      let (:signature) { liqpay.encode_signature json_data }
      let (:decoded_signature) { Base64.strict_decode64 signature }
      let (:expected_signature) { Digest::SHA1.digest private_key + json_data + private_key }

      it 'calculates request signature' do
        expect(decoded_signature).to eq expected_signature
      end
    end

    describe '#check_signature' do

      let (:data_signature) do
        Base64.strict_encode64 Digest::SHA1.digest private_key + json_data + private_key
      end

      let (:bad_signature) do
        Base64.strict_encode64 Digest::SHA1.digest private_key + json_data
      end

      it 'checks response signature' do
        expect(liqpay.check_signature(json_data, data_signature)).to be true
      end

      it 'returns false for wrong signature' do
        expect(liqpay.check_signature(json_data, bad_signature)).to be false
      end
    end

    describe '#cnb_form_fields' do

      let(:form_fields) { liqpay.cnb_form_fields data }

      let :request_signature do
        Base64.strict_encode64 Digest::SHA1.digest private_key + form_fields[:data] + private_key
      end

      it 'returns fields for payment form' do
        expect(form_fields).to be_a Hash
        expect(form_fields.length).to eq 2
      end

      it 'includes data' do
        expect(form_fields[:data]).to be_a String
      end

      it 'includes signature' do
        expect(form_fields[:signature]).to eq request_signature
      end

      describe 'request' do
        let(:request) { JSON.parse(Base64.strict_decode64 form_fields[:data]).symbolize_keys }

        it 'includes version' do
          expect(request[:version]).to eq 3
        end

        it 'includes public key' do
          expect(request[:public_key]).to eq public_key
        end

        it 'includes data' do
          data.each do |key, value|
            expect(request[key.to_sym]).to eq value
          end
        end
      end
    end
  end
end

