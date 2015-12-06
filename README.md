sinatra-personal-webpage
========================

My personal webpage written in Sinatra

Run it by executing `shotgun`

bundle exec rake test:all

When cloning the repo, copy config/config.yml.dist to config/config.yml

## Start server

`bundle exec unicorn -c unicorn.rb -E development -D`


## Deployment

`cap (production|staging) deploy`
