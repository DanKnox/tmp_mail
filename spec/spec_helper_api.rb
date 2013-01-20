ENV['GUARD_ENV'] = 'test'
ENV['MONGO_ENV'] = 'test'

$:.push File.expand_path("../../lib", __FILE__)

require "bundler/setup"
require "rspec/autorun"
require "tmp_mail"
require "tmp_mail/api/api"
require "rack/test"
require "database_cleaner"

DatabaseCleaner.strategy = :truncation

Dir["#{File.dirname(__FILE__)}/support/**"].each { |f| require f }

FIXTURES = File.expand_path("../fixtures", __FILE__)

ENV['RACK_ENV'] = 'test'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'
  config.include Rack::Test::Methods
  config.after(:each) { DatabaseCleaner.clean }
end

def app
  TmpMail::Api
end

def response
  last_response
end
