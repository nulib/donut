# prod
# EZID_DEFAULT_SHOULDER: ark:21985/N2
# EZID_USER: user
# EZID_PASSWORD: password
# EZID_HOST: ezid.lib.purdue.edu\
# EZID_PORT: 443
# EZID_USE_SSL: true

Ezid::Client.configure do |conf|
  conf.default_shoulder = 'ark:/99999/fk4' unless ENV['EZID_DEFAULT_SHOULDER']
  conf.user = 'apitest' unless ENV['EZID_USER']
  conf.password = 'apitest' unless ENV['EZID_PASSWORD']
  conf.host = 'ezid.lib.purdue.edu' unless ENV['EZID_HOST']
  conf.port = 443 unless ENV['EZID_PORT']
  conf.use_ssl = true unless ENV['EZID_USE_SSL']
end
