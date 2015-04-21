require 'base64'
require 'digest/sha1'
require 'json'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    class Liqpay < Gateway

      def initialize(public_key, private_key)
        @public_key = public_key
        @private_key = private_key
      end

      def cnb_form_fields(options)
        params = {version: 3, public_key: @public_key}.merge(options)
        data = encode64 encode_json params
        {
          data: data,
          signature: encode_signature(data)
        }
      end

      def encode64(param)
        Base64.strict_encode64(param).chomp
      end

      def encode_json(params)
        JSON.generate(params)
      end

      def encode_signature(param)
        encode64 Digest::SHA1.digest(@private_key + param + @private_key)
      end

      def check_signature(data, signature)
        signature == encode_signature(data)
      end
    end
  end
end
