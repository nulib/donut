source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.1'
# Install both postgres & sqlite3 adapters
gem 'pg'
gem 'sqlite3'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Use SCSS for stylesheets
gem 'bootstrap-sass', '>= 3.4.1'
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'hydra-derivatives', github: 'nulib/hydra-derivatives', branch: 'vips'
gem 'hyrax', github: 'nulib/hyrax', branch: '2.4.1-plus-be'
gem 'nulib_microservices', github: 'nulib/nulib_microservices'

gem 'config'
gem 'exiftool_vendored'
gem 'ezid-client'
gem 'honeybadger', '~> 4.0'
gem 'httparty'
gem 'hydra-role-management'
gem 'omniauth-openam'

gem 'common_indexer', '~> 0.3'
gem 'donut-retry', github: 'nulib/donut-retry', branch: 'master'

gem 'edtf'
gem 'edtf-humanize'

gem 'rubyzip', '~> 1.2.2', require: 'zip'

gem 'zk'

group :test do
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'hyrax-spec', '~> 0.2'
  gem 'rspec-activemodel-mocks', '~> 1.0'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'jasmine'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rubocop', '~> 0.49.1', require: false
  gem 'rubocop-rspec', require: false
  gem 'selenium-webdriver'
end

group :development, :aws do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2', require: false
  gem 'web-console', '>= 3.3.0', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :development, :test do
  gem 'docker-api'
  gem 'docker-compose'
  gem 'docker-stack'
  gem 'fcrepo_wrapper'
  gem 'rspec-rails'
  gem 'sidekiq'
  gem 'solr_wrapper', '>= 0.3'
  gem 'webmock'
end

gem 'devise'
gem 'devise-guests', '~> 0.6'
gem 'jquery-rails'
gem 'rsolr', '>= 1.0'

group :aws, :test do
  gem 'active_elastic_job', github: 'nulib/active-elastic-job', branch: 'latest-aws-sdk'
end

group :aws do
  gem 'aws-sdk', '~> 3'
  gem 'aws-sdk-rails'
  gem 'carrierwave-aws'
  gem 'cloudfront-signer'
  gem 'redis-rails'
end

group :production do
  # gem 'clamav'
  gem 'lograge'
end
