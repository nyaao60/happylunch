require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Happylunch
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
   # 日本語の言語設定。この一行を追加。
   config.i18n.default_locale = :ja
    # 時刻を日本時間に
   config.time_zone = 'Tokyo'
  # デフォルトのロケールを日本（ja）に設定
  config.i18n.default_locale = :ja
  end
end
