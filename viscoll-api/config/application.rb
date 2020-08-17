require_relative 'boot'
require_relative 'shrine'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
# require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ViscollApi
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    Mongo::Logger.logger.level = Logger::FATAL
    config.log_level = :warn

    # Rack CORS for handling Cross-Origin Resource Sharing (CORS)
    config.middleware.use Rack::Cors do
      allow do
        origins '*'
        resource '*',
          :headers => :any,
          :expose  => ['access-token', 'expiry', 'token-type', 'uid', 'client'],
          :methods => [:get, :patch, :put, :delete, :post, :options]
      end
    end

    config.action_mailer.smtp_settings = {
      :user_name            => ENV['MAILER_USR'],
      :password             => ENV['MAILER_PWD'],
      :from                 => ENV['MAILER_DEFAULT_FROM'],
      :domain               => ENV['MAILER_DOMAIN'],
      :address              => ENV['MAILER_HOST'],
      :port                 => ENV['MAILER_PORT'] || 587,
      :authentication       => :plain,
      :enable_starttls_auto => true
    }
    config.action_mailer.default_url_options = { :host => ENV['APPLICATION_HOST'] }
  end
end
