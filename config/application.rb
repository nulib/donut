require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Nextgen
  class Application < Rails::Application
    config.generators do |g|
      g.test_framework :rspec, spec: true
    end

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    if ENV['REDIS_HOST']
      redis_host = ENV['REDIS_HOST']
      redis_port = ENV['REDIS_PORT'] || 6379

      config.cache_store = :redis_store, {
        host: redis_host,
        port: redis_port,
        db: 0,
        namespace: 'donut-cache'
      }
    end
  end
end
