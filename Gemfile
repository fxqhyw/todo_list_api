source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

gem 'rails'
gem 'pg'
gem 'puma'
gem 'mini_magick'
gem 'rack-cors'
gem 'figaro'
gem 'devise_token_auth'
gem 'acts_as_list'
# gem 'jbuilder', '~> 2.5'
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  gem 'rspec-rails'
  gem 'ffaker'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rubocop'
  gem 'pry-rails'
  gem 'pry-byebug'
end

group :test do
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'json_matchers'
  gem 'factory_bot_rails'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
