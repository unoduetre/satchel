# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.2.2'

gem 'bootsnap', require: false
gem 'dartsass-rails', '~> 0.5.0'
gem 'importmap-rails', '~> 1.2'
gem 'pg', '~> 1.5'
gem 'puma', '~> 6.4'
gem 'rails', '~> 7.1.1'
gem 'redis', '~> 5.0'
gem 'sprockets-rails', '~> 3.4'
gem 'stimulus-rails', '~> 1.3'
gem 'tailwindcss-rails', '~> 2.0'
gem 'textacular', '~> 5.6'
gem 'turbo-rails', '~> 1.5'
gem 'tzinfo-data', platforms: %i[windows jruby]

group :development, :test do
  gem 'brakeman'
  gem 'bundler-audit'
  gem 'factory_bot_rails', '~> 6.2'
  gem 'faker', '~> 3.2'
  gem 'pry-byebug'
  gem 'pry-doc'
  gem 'pry-inline'
  gem 'pry-rails'
  gem 'pry-rescue'
  gem 'pry-stack_explorer'
end

group :development do
  gem 'memory_profiler'
  gem 'rack-mini-profiler', require: false
  gem 'rubocop-factory_bot', require: false
  gem 'rubocop-faker', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'stackprof'
  gem 'web-console'
end

group :test do
  gem 'rspec-rails', '~> 6.0'
  gem 'shoulda-matchers', '~> 5.3'
  gem 'simplecov', require: false
end
