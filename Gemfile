source "https://rubygems.org"

ruby ENV["HEROKU_RUBY_VERSION"] if ENV["HEROKU_RUBY_VERSION"]

gem "rails", "~> 6.1.0"
gem "pg"
gem "puma"

group :development do
  gem "dotenv-rails"
end

group :development, :test do
  gem "sqlite3", "~> 1.4"
  gem "listen"
end

group :test do
  gem "mutant-minitest", require: false
  gem "mutant", require: false
  gem "mutant-license", require: false, source: "https://oss:7AXfeZdAfCqL1PvHm2nvDJO6Zd9UW8IK@gem.mutant.dev"
end
