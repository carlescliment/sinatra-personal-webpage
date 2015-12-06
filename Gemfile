source "http://rubygems.org"
gem "sinatra"
gem "rake"
gem "sinatra-flash", "~> 0.3.0"
gem "sinatra-config-file"
gem "thin"
gem "haml"
gem "pony"
gem "metadown", :git => 'git://github.com/steveklabnik/metadown.git'
gem "pygments.rb"
gem "unicorn"

#bundle install --without test development
group :test do
  gem "rack-test"
  gem "rspec"
  gem "capybara"
end

group :development do
  gem 'shotgun'
  gem 'capistrano', '~> 3.4.0'
  gem 'capistrano-rvm'
  gem 'capistrano-passenger'
  gem 'capistrano-bundler'
end
