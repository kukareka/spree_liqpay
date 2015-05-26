require 'spec_helper'

module Spree
  describe 'spree_liqpay', type: :feature, js: true do
    let(:product_name) { 'Ohlins TPX44' }
    before do
      create :check_payment_method
      create :simple_credit_card_payment_method
      @liqpay = create :liqpay
      create :country
      create :global_zone
      create :free_shipping_method, display_on: :front_end
      create :product, name: product_name
    end

    it 'adds liqpay payment option on frontend' do
      make_order
      choose 'Check'
      expect(form_action).to eq default_checkout_url
      choose 'Liqpay'
      expect(form_action).to eq @liqpay.checkout_url
      choose 'Credit Card'
      expect(form_action).to eq default_checkout_url
      choose 'Liqpay'
      expect(form_action).to eq @liqpay.checkout_url
      expect(page).to have_selector 'form.edit_order input[type=hidden][name=data]'
      expect(page).to have_selector 'form.edit_order input[type=hidden][name=signature]'
      visit spree.liqpay_result_order_checkout_path order_id: current_order.id
      expect(page).to have_selector '#liqpay_spinner'
      simulate_liqpay_callback
      using_wait_time 1000 do
        expect(page).to have_selector '#order_summary'
      end
      expect(current_url).to eq completed_order_url
    end

    private

    def simulate_liqpay_callback
      data = {
          order_id: current_order.id,
          currency: current_order.currency,
          amount: current_order.total.to_digits,
          type: 'buy',
          status: 'sandbox'
      }
      encoded_data = @liqpay.provider.encode data
      uri = URI spree.liqpay_status_update_url payment_method_id: @liqpay.id, host: current_host, port: Capybara.current_session.server.port
      res = Net::HTTP.post_form uri, data: encoded_data,
                                     signature: @liqpay.provider.encode_signature(encoded_data)
      expect(res.code).to eq '200'
    end

    def completed_order_url
      spree.order_url current_order, host: current_host, port: Capybara.current_session.server.port
    end

    def default_checkout_url
      spree.update_checkout_url 'payment', host: current_host, port: Capybara.current_session.server.port
    end

    def form_action
      find('form.edit_order')['action']
    end

    def current_order
      Order.last
    end

    def make_order
      visit spree.root_path
      click_link product_name
      click_button 'Add To Cart'
      click_button 'Checkout'
      fill_address
      click_button 'Save and Continue'
      click_button 'Save and Continue'
    end

    def fill_address
      fill_in 'order_email', with: email
      within '#billing' do
        fill_in 'First Name', with: first_name
        fill_in 'Last Name', with: last_name
        fill_in 'Street Address', with: street_address
        fill_in 'City', with: city
        select 'United States of America', from: 'order_bill_address_attributes_country_id'
        select 'Alabama', from: 'order_bill_address_attributes_state_id'
        fill_in 'Zip', with: zip_code
        fill_in 'Phone', with: phone_number
      end
    end
  end
end
