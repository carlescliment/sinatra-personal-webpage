sinatra-personal-webpage
========================

My personal webpage written in Sinatra

Run it by executing `shotgun`

bundle exec rake test:all

When cloning the repo, copy config/config.yml.dist to config/config.yml

## Deploy with phussion passenger

[Guide for installing Phussion Passenger on Ubuntu](http://www.rabblemedia.net/installing-rvm-ruby-on-rails-and-passenger-on-ubuntu.html)


Deployment with Capistrano is still not finished.

`bundle install --deployment`
`bundle exec rake blog:reindex`
