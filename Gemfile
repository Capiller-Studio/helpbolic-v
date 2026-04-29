# frozen_string_literal: true

source "https://rubygems.org"

ruby "3.4.1"

gem "rails", ">= 8.0.1"
gem "propshaft"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"

# Asset handling
gem "jsbundling-rails"
gem "cssbundling-rails"
gem "turbo-rails"
gem "stimulus-rails"

# Shared backend
gem 'core', path: "../core"

# Templating
gem 'slim-rails'
gem 'liquid'

# Pagination
gem 'pagy', '~> 6.2'

# Security
gem 'rack-attack'

# JSON
gem 'oj'

# Search
gem 'searchkick'
gem 'elasticsearch'

# Reduces boot times through caching
gem "bootsnap", require: false

group :development, :test do
  gem 'pry'
  gem 'pry-rails'
  gem 'awesome_print'
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
end

group :development do
  gem "web-console"
end
