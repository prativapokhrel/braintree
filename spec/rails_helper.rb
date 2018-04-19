require 'database_cleaner'
require 'simplecov'
SimpleCov.start('rails') do
  coverage_dir 'coverage'
  add_group 'Modules' , 'app/modules'
  add_filter "lib/api_constraints.rb"
  add_filter "app/uploaders/"
  add_filter "app/models/redactor_rails/"
  add_filter "app/controllers/application_controller.rb"
  add_filter "app/models/application_record.rb"
  add_filter "app/workers/"
end

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
# Add additional requires below this line. Rails is not loaded until this point!


require 'capybara/rspec'
require 'capybara/poltergeist'

require 'rack_session_access/capybara'
require 'capybara-screenshot/rspec'

Capybara.javascript_driver = :poltergeist
Capybara.save_path = "#{ Rails.root }/tmp/screenshots/"

Capybara.raise_server_errors = false
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(
    app,
    {
      js_errors: false,
      port: 44678+ENV['TEST_ENV_NUMBER'].to_i,
      phantomjs_options:['--proxy-type=none'],
      timeout:180,
      default_max_wait_time:180,
      phantomjs_logger: File.open(File::NULL, 'w')
    })
end
Capybara.default_max_wait_time = 10
Capybara.asset_host = 'http://localhost:3000'
Capybara.configure do |config|
  config.match = :prefer_exact
  config.ignore_hidden_elements = false
  config.visible_text_only = true
end
Capybara.always_include_port = true

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migration and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|

  config.expect_with :rspec do |c|
    # enable both should and expect
    c.syntax = [:should, :expect]
  end
  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  config.append_after(:each) do
    Capybara.reset_sessions!
  end

  config.include Capybara::DSL

  config.order = "random"
  config.use_transactional_fixtures = false



  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    # compile front end
    `bin/webpack`
  end

  config.before(:each) do
    #slack_queue = Sidekiq::Queue.new("slack")
    #omniauth_queue = Sidekiq::Queue.new("omniauth_attach_image_to_user")
    DatabaseCleaner.strategy = Capybara.current_driver == :rack_test ? :transaction : :truncation
    DatabaseCleaner.clean
    DatabaseCleaner.start
    #slack_queue.clear
    #omniauth_queue.clear
  end

  config.after(:each) do
    Capybara.app_host = nil
    DatabaseCleaner.clean
  end



  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

end
