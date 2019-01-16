sinatra-personal-webpage
========================

My personal webpage written in Sinatra

Run it by executing `shotgun`

bundle exec rake test:all

When cloning the repo, copy config/config.yml.dist to config/config.yml

## Requirements

```
(as deploy user)
mkdir /home/deploy/tmp
cd /home/deploy/tmp
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
\curl -sSL https://get.rvm.io | bash -s stable --ruby
rvm install ruby-2.5.1-p481
gem install eventmachine -v '1.0.3'
```


Add to `/etc/nginx/nginx.conf` http section:

```
        upstream unicorn_server {
            server unix:/var/www/carlescliment.com/current/tmp/sockets/unicorn.sock
            fail_timeout=0;
        }
```

## Start server

`bundle exec unicorn -c unicorn.rb -D`

In production: `/home/deploy/.rvm/bin/rvm default do bundle exec unicorn -c unicorn.rb -D`


## Deployment

`cap (production|staging) deploy`
