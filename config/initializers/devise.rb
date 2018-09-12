Devise.setup do |config|
  config.secret_key = Figaro.env.devise_secret_key if Rails.env.production?
end
