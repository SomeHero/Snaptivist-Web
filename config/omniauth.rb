Rails.application.config.middleware.use OmniAuth::Builder do
  provider :nation_builder, YOUR_APP_ID, YOUR_APP_SECRET
end
