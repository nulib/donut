Rails.application.config.middleware.use OmniAuth::Builder do
  provider :nusso,
           'https://northwestern-prod.apigee.net/agentless-websso/',
           Settings.nusso.consumer_key
end
