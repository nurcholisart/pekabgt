# frozen_string_literal: true

require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require_relative "../lib/internal/pekabgt/logger"

module Pekabgt
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = "UTC"
    # config.eager_load_paths << Rails.root.join("extras")
    config.exceptions_app = routes

    config.action_dispatch.default_headers = {
      "X-Frame-Options" => "ALLOWALL"
      # "X-XSS-Protection" => "1; mode=block",
      # "X-Content-Type-Options" => "nosniff"
    }

    # Specify cookies SameSite protection level: either :none, :lax, or :strict.
    # This change is not backwards compatible with earlier Rails versions.
    # It's best enabled when your entire app is migrated and stable on 6.1.
    # Was not in Rails 6.0. Default in rails 6.1 is :lax, not :strict
    # config.action_dispatch.cookies_same_site_protection = :none

    config.active_job.queue_adapter = :good_job
  end
end
