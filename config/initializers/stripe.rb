Rails.configuration.stripe = {
  :publishable_key => "#{ENV['pk_test_iCTdFsCIrSwL66E1W2Bu8gaF00DS79bE7v']}",
  :secret_key => "#{ENV['sk_test_0fqo5JXcf5hd9o2l6kbVptUR00X7CN8gEm']}"
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]