source "https://rubygems.org"

ruby ENV["HEROKU_RUBY_VERSION"] if ENV["HEROKU_RUBY_VERSION"]

gem "rails", "~> 7.0.4"
gem "pg"
gem "puma"
gem "honeybadger"

group :development do
  gem "dotenv-rails"
end

group :test do
  gem "mutant-minitest", require: false
  gem "mutant", require: false
  gem "mutant-license", require: false, source: "https://oss:7AXfeZdAfCqL1PvHm2nvDJO6Zd9UW8IK@gem.mutant.dev"
end
gem "rails_event_store", "~> 2.9.0"
