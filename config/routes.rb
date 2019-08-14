Rails.application.routes.draw do
  devise_for :users
  resources :products

  #root 'products#index'
  get 'products/index'

  root 'storefront#all_items'
  get 'categorical'  => 'storefront#items_by_category'
  get 'branding'     => 'storefront#items_by_brand'

  get  'view_order'  => 'cart/view_order'
  get  'checkout'    => 'cart/checkout'
  post "add_to_cart" => 'cart/add_to_cart'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
