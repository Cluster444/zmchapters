require 'rubygems'
require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'shoulda/integrations/rspec2'

  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
  RSpec.configure do |config|
    config.mock_with :rspec
    config.use_transactional_fixtures = true
  end
end

Spork.each_run do
  # A hack to get factory girl to reload the models for spork. FG is installed into 
  # the development only group so is not loaded globally within a test environement
  require 'factory_girl'
  Dir[File.expand_path(File.join(File.dirname(__FILE__),'factories.rb'))].each {|f| require f}
end

