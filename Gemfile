source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

gem "rails", "~> 7.0.3"
gem "pg", "~> 1.3.5"
gem "puma", "~> 5.6.4"

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.12.0', require: false

gem 'aasm', '~> 5.2'
gem 'dry-schema', '~> 1.9.2'
gem 'dry-struct', '~> 1.4.0'
gem 'paper_trail', '~> 12.3.0'
gem 'sidekiq', '~> 6.5.0'
gem 'sidekiq-cron', '~> 1.5.1'
gem 'rack-cors'
gem 'devise'
gem 'devise-jwt'
gem 'fast_jsonapi' # TODO: use gem 'jsonapi-serializer'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 5.1.2'
  gem 'factory_bot_rails'
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'dotenv-rails'
end

group :development do
  gem 'pry-byebug'
  gem 'aasm-diagram', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
