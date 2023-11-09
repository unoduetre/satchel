# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.2.2'

gem 'dotenv-rails', groups: %i[development test]

gem 'bootsnap', require: false
gem 'dartsass-rails'
gem 'importmap-rails'
gem 'jbuilder'
gem 'pg', '~> 1.1'
gem 'puma', '>= 5.0'
gem 'rails', '~> 7.1.1'
gem 'redis', '>= 4.0.1'
gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'turbo-rails'
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
end
