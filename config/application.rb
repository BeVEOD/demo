require File.expand_path('../boot', __FILE__)

require 'rails/all'
RAILS_GEM_VERSION = Rails.version unless defined?(RAILS_GEM_VERSION)
APP_SID = File.basename(File.expand_path(File.join(File.dirname(__FILE__), '..'))).sub(/_...\Z/, '') unless defined?(APP_SID)


# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.

Bundler.require(:default, Rails.env) if defined?(Bundler)

module DemoApp
  class Application < Rails::Application

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.



    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)

    config.autoload_paths += Dir["#{config.root}/lib/**/"]


    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]



    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer



    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'



    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de



    # JavaScript files you want as :defaults (application.js is always included).
    # config.action_view.javascript_expansions[:defaults] = %w(jquery rails)


    config.time_zone = 'UTC'
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.secret_token = "#{APP_SID}&#{IO.read(Rails.root.join('log', 'session.secret'))}"
    config.i18n.default_locale = :en
    config.i18n.fallbacks = true
    config.active_record.include_root_in_json = false
    config.i18n.available_locales = %w(en fr de ar zn)
    config.active_record.store_full_sti_class = true

  end
end
