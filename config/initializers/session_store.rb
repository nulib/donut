if ENV['REDIS_HOST']
  redis_host = ENV['REDIS_HOST']
  redis_port = ENV['REDIS_PORT'] || 6379

  Rails.application.config.session_store :redis_store,
                                         servers: ["redis://#{redis_host}:#{redis_port}/"],
                                         expires_in: 90.minutes,
                                         key: "_#{Rails.application.class.parent_name.downcase}_session"
end
