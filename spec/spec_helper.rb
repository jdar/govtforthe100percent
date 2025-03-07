require "simplecov"
SimpleCov.start

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../config/environment', __dir__)
require "rspec/rails"
require "webmock/rspec"

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = Rails.root.join("/spec/fixtures")

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
end

Geocoder.configure(lookup: :test)

Geocoder::Lookup::Test.add_stub(
  "123 Example St., San Francisco, CA, US",
  [
    {
      "latitude" => 37.7749295,
      "longitude" => -122.41941550000001,
      "address" => "123 Example St., San Francisco, CA, USA",
      "state" => "California",
      "state_code" => "CA",
      "country" => "United States",
      "country_code" => "US"
    }
  ]
)

Geocoder::Lookup::Test.add_stub(
  [37.8044, -122.2708],
  [
    {
      "latitude" => 37.8044652,
      "longitude" => -122.27081,
      "address" => "1400 Broadway, Oakland, CA 94612, USA",
      "street" => "1400 Broadway",
      "city" => "Oakland",
      "state" => "California",
      "state_code" => "CA",
      "country" => "United States",
      "country_code" => "US"
    }
  ]
)
