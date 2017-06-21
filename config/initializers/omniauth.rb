Rails.application.config.middleware.use OmniAuth::Builder do
  provider :openam, 'https://websso.it.northwestern.edu/amserver', cookie_name: 'openAMssoToken'
end
