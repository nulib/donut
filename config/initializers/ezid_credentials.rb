# prod
# EZID_DEFAULT_SHOULDER: ark:21985/N2
# EZID_USER: user
# EZID_PASSWORD: password
# EZID_HOST: ezid.lib.purdue.edu\
# EZID_PORT: 443
# EZID_USE_SSL: true

Ezid::Client.configure do |conf|
  conf.default_shoulder = Settings.ark.default_shoulder
  conf.user = Settings.ark.user
  conf.password = Settings.ark.password
  conf.host = Settings.ark.host
  conf.port = Settings.ark.port
  conf.use_ssl = [true, 'true', 1, '1'].include?(Settings.ark.use_ssl)
end
