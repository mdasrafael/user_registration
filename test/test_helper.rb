ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'database_cleaner'

# Load seed data before factory girl
DatabaseCleaner.clean_with :truncation
load File.join(File.dirname(__FILE__), '../db/seeds.rb')

require 'factory_bot_rails'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  # Add more helper methods to be used by all tests here...
end
