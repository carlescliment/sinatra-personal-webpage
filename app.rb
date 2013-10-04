require 'sinatra'
require 'sinatra/flash'
require 'sinatra/config_file'
require 'pony'
require 'glorify'


class PersonalWebPage < Sinatra::Base
  enable :sessions
  register Sinatra::Flash
  register Sinatra::ConfigFile
  register Sinatra::Glorify
  config_file 'config/config.yml'

  get '/' do
    haml :profile, :format => :html5
  end

  get '/contact' do
    haml :contact, :format => :html5
  end

  post '/contact' do
    sender = params[:email]
    message = params[:message]

    Pony.mail :to => settings.contact['to_address'],
              :from => settings.contact['from_address'],
              :subject => 'Contact from your personal webpage',
              :body => "#{sender} : #{message}"

    flash.next[:info] = "Thanks, the e-mail has been sent. I'll respond to you as soon as possible. Promise!"
    redirect '/contact'
  end

  get '/post' do
    content = File.open("#{File.dirname(__FILE__)}/_posts/2011-12-08-instalar-sonar-en-proyectos-php.md", "rb").read
    haml :post, :format => :html5, :locals => { :content => content }
  end
end

