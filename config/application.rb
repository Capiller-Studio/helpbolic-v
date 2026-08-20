# frozen_string_literal: true

require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module Helpbolic
  class Application < Rails::Application
    config.load_defaults 8.0

    config.autoload_lib(ignore: %w[assets tasks])

    # Multi-language configuration
    config.i18n.available_locales = Core::SUPPORTED_LOCALES
    config.i18n.default_locale = :en
    config.i18n.fallbacks = true

    # Routing and Middleware
    config.middleware.use Rack::Deflater
    config.exceptions_app = routes

    # Ensure helper and constraint paths are loaded
    config.autoload_paths << Rails.root.join("app", "lib")

    # Disable Host Authorization middleware for multi-tenant domains
    config.hosts.clear
  end
end
