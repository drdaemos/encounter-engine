source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 3.0'

gem 'acts_as_list'
gem 'bcrypt', platforms: :ruby
gem 'devise' # Authorization
gem 'bitmask_attributes'
gem 'webpacker', '~> 3.2.2'
gem 'carrierwave', '~> 1.0'
gem 'mini_magick'
gem 'time_diff'

gem "cells"
gem "cells-rails"
gem "cells-erb"

gem "interactor"
gem "interactor-rails"

gem 'friendly_id', '~> 5.1.0'
gem 'babosa'

# oauth
gem 'omniauth-vkontakte'
gem 'omniauth-google-oauth2'
gem 'omniauth-yandex'

group :production do
  # PostgresQL
  gem 'pg', '~> 0.18'
  gem "lograge"
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13.0'
  gem 'cucumber', '0.10.6'
  gem 'cucumber-rails', '0.3.2'
  gem 'launchy'
  gem 'webrat'
  gem 'nokogiri'
  gem 'loofah', '~> 2.2.1'
  gem 'rspec'
  gem 'rspec-rails', '~> 3.7'

  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'

  # Deployment
  gem 'capistrano', '~> 3.6'
  gem "capistrano-rails", "~> 1.2"
  gem "capistrano3-puma"
  gem "capistrano-passenger", "~> 0.2.0"
  gem "capistrano-yarn"
  gem 'capistrano-local-precompile', '~> 1.0.0'
  #Add this if you"re using rbenv
  gem "capistrano-rbenv", "~> 2.1"
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'foreman'