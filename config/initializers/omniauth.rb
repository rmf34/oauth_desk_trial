Rails.application.config.middleware.use OmniAuth::Builder do
  # provider :developer unless Rails.env.production?
  provider :desk, ENV['DESK_KEY'], ENV['DESK_SECRET']
end
