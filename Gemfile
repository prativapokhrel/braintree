source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.5'
gem 'sqlite3'
gem 'puma', '~> 3.7'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'

gem 'therubyracer'
gem 'braintree'
gem 'bootstrap-sass', '3.3.7'
gem 'font-awesome-rails'
gem 'less-rails-bootstrap'
gem 'sass-rails', '~> 5.0'
gem 'jquery-rails'


group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'selenium-webdriver'
  gem 'haml'
  gem 'pry'
  gem "rspec-rails"
  gem 'capybara'
  gem 'capybara-screenshot'
  gem 'machinist'
  gem 'poltergeist'
  gem 'rails-controller-testing', '~> 0.0.3'
  gem 'database_cleaner'
  gem 'faker'
  gem 'rack_session_access'
  gem 'simplecov'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
