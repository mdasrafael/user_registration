require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module UserRegistration
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Load environment variables
    config.before_configuration do
		  env_file = File.join(Rails.root, 'config', ENV['RAILS_ENV']+'.yml')
		  YAML.load(File.open(env_file)).each do |key, value|
		    ENV[key.to_s] = value
		  end if File.exists?(env_file)
		end
  end
end
