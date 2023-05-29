# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.3"

gem "bootsnap", require: false
gem "cssbundling-rails"
gem "down", "~> 5.4"
gem "good_job", "~> 3.15"
gem "http", "~> 5.1"
gem "inline_svg", "~> 1.9"
gem "jbuilder"
gem "jsbundling-rails"
gem "jwt", "~> 2.7"
gem "lograge", "~> 0.12.0"
gem "ougai", "~> 2.0"
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
gem "qismo", "~> 0.18.3"
gem "rack-cors", "~> 2.0"
gem "rails", "~> 7.0.4", ">= 7.0.4.3"
gem "redis", "~> 4.0"
gem "reverse_markdown", "~> 2.1"
gem "sprockets-rails"
gem "stimulus-rails"
gem "store_attribute", "~> 1.1"
gem "turbo-rails"
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
gem "ulid", "~> 1.4"

group :development, :test do
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "figaro", "~> 1.2"
  gem "rubocop-rails", "~> 2.19", require: false
end

group :development do
  gem "annotate", "~> 3.2"
  gem "dockerfile-rails", ">= 1.2"
  gem "web-console"
  gem "yard", "~> 0.9.34"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end

gem "redcarpet", "~> 3.6"
