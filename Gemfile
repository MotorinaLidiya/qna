source 'https://rubygems.org'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 6.1.0'
# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'sprockets-rails'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.5'
# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 5.0'
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'

gem 'sidekiq'
# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mswin mswin64 mingw x64_mingw jruby]

gem 'active_storage_validations'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false
gem 'devise'
# OAuth 2 provider
gem 'doorkeeper'

gem 'slim-rails'
# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'

gem 'jquery-rails'
gem 'webpacker', '~> 5.4'
# UI
gem 'bootstrap', '~> 5.3.3'

# NETWORKING
gem 'dotenv-rails'
# Cloud
gem 'aws-sdk-s3', require: false
# Dynamic cell addition
gem 'cocoon'

# OAuth
gem 'omniauth'
gem 'omniauth-github'
gem 'omniauth-rails_csrf_protection'
gem 'omniauth-vkontakte'

# authorization library
gem 'cancancan'

gem 'active_model_serializers', '~> 0.10'
gem 'concurrent-ruby', '1.3.4'
gem 'oj', '~> 3.13'

gem 'database_cleaner-active_record'
gem 'opensearch-model', github: 'compliance-innovations/opensearch-rails'
gem 'opensearch-rails', github: 'compliance-innovations/opensearch-rails'

gem 'bcrypt_pbkdf', '~> 1.0'
gem 'ed25519', '~> 1.2'

gem 'redis-rails'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri mswin mswin64 mingw x64_mingw], require: 'debug/prelude'

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem 'brakeman', require: false

  # Tests
  gem 'factory_bot_rails'
  gem 'rspec-rails'

  gem 'capybara-email'
  gem 'letter_opener_web'
end

group :production do
  # Use Redis adapter to run Action Cable in production
  gem 'redis', '~> 4.8'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'capistrano', require: false
  gem 'capistrano3-puma', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rbenv', require: false
  gem 'capistrano-sidekiq', require: false
  gem 'capistrano-yarn', require: false
  gem 'web-console'
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara'
  gem 'email_spec'
  gem 'rubocop-rails', require: false
  gem 'selenium-webdriver'

  gem 'json_spec'
  gem 'launchy'
  gem 'rails-controller-testing'
  gem 'shoulda-matchers'
end
