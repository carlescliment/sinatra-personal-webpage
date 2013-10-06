require 'sinatra'
require 'sinatra/flash'
require 'sinatra/config_file'
require 'pony'

require_relative './model/markdown_post_provider'

class PersonalWebPage < Sinatra::Base
  enable :sessions
  register Sinatra::Flash
  register Sinatra::ConfigFile
  config_file 'config/config.yml'

  get '/' do
    haml :profile
  end

  get '/contact' do
    haml :contact
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

  get '/blog/:title' do |title|
    path = settings.root + '/' + settings.blog['source_dir']
    post = MarkdownPostProvider.load(title, path)
    haml :post, :locals => { :post => post }
  end
end

