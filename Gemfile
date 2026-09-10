# frozen_string_literal: true

source "https://rubygems.org"

ruby "4.0.6"

gem "rails", ">= 8.1.3"
gem "propshaft"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "bootsnap", require: false
gem "jbuilder"
gem "dotenv-rails"

# Asset handling
gem "jsbundling-rails"
gem "cssbundling-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "slim-rails"

group :development, :test do
  gem 'pry'
  gem 'pry-rails'
  gem 'awesome_print'
  gem 'factory_bot_rails'
  gem 'ffaker'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'database_cleaner-active_record'
  gem 'timecop'
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'rubocop-rails-omakase', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-thread_safety', require: false
  gem 'rubocop-capybara', require: false
  gem 'rubocop-minitest', require: false
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
end

group :development do
  gem 'annotate'
  gem 'bullet'
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end

# ============================================================================
# Shared Backend (Core)
# ============================================================================
gem 'core', path: "../core"
