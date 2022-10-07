require 'alphavantage'

Alphavantage.configure do |config|
  config.api_key = Rails.application.credentials.alphavantage[:access_key_id]
end
