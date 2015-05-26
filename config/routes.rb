Spree::Core::Engine.routes.draw do
  resources :orders do
    resource :checkout, :controller => 'checkout' do
      member do
        get :liqpay_result
        get :liqpay_status
      end
    end
  end

  post '/liqpay_status/:payment_method_id' => 'liqpay_status#update', :as => :liqpay_status_update

end