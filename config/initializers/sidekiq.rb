if defined?(Sidekiq)
  redis_proc = lambda {
    config = YAML.safe_load(ERB.new(IO.read(Rails.root.join('config', 'redis.yml'))).result)[Rails.env].with_indifferent_access
    Redis.new(config.merge(thread_safe: true))
  }

  Sidekiq.configure_client do |config|
    config.redis = ConnectionPool.new(size: 15, &redis_proc)
  end

  Sidekiq.configure_server do |config|
    config.redis = ConnectionPool.new(size: 15, &redis_proc)
  end
end
