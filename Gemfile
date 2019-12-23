source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.0'

gem 'rails', '~> 5.2.3'
gem 'sqlite3'
gem 'puma', '~> 3.12'
gem 'rack-cors'
group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
end

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'rspec-rails', '~> 3.8', '>= 3.8.2'
  gem 'shoulda-callback-matchers', '~> 1.1', '>= 1.1.4', require: false
  gem 'ffaker'
  gem 'database_cleaner', '~> 1.7'
  gem 'capybara', '~> 3.24'
  gem 'shoulda-matchers'
  gem 'factory_bot_rails', '~> 5.0', '>= 5.0.2'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
