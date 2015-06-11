# Spree Liqpay

[Liqpay.com](https://www.liqpay.com/en/) payment gateway API for [Spree E-Commerce](https://spreecommerce.com/).
 
## Installation
 
Update your `Gemfile`:

```ruby
gem 'spree_liqpay', github: 'kukareka/spree_liqpay'
```

Run `Bundler`:

```
bundle install
```
  
## Configuration
  
1. Login to Spree Backend. 

2. Open "Configurations -> Payment Methods"

3. Click "New Payment Method".

4. Choose provider "Spree::PaymentMethod::Liqpay".

5. Enter any name and description. It will be visible to client during checkout. Click "Create".

6. Enter your public and private keys retrieved from [liqpay.com](https://www.liqpay.com/en/).

7. Enter order description (it will be visible to client during checkout on Liqpay site).

8. Turn off the Test mode.
  
## How it works

1. A client selects Liqpay payment method on Payment tab during checkout on our site.
2. We redirect him to payment form on Liqpay.com where he makes the payment.
3. Liqpay.com redirects the client back to our site.
4. We wait for a callback from Liqpay.com (takes a few seconds) and redirect the client to "Order complete" page.

## Tests

Powered by [RSpec](http://rspec.info/), [Capybara](https://github.com/jnicklas/capybara) and [Selenium](http://www.seleniumhq.org/).

Run `rake app:setup` before the tests to init the dummy app.  

## References

1. [Liqpay.com official Ruby SDK](https://github.com/liqpay/sdk-ruby) (not used by this gem)
2. [Liqpay.com FAQ](https://www.liqpay.com/en/faq)
3. [Liqpay.com API reference](https://www.liqpay.com/en/doc)


