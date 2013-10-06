require 'sinatra'
require 'sinatra/flash'
require 'sinatra/config_file'
require "sinatra/content_for"
require 'pony'

require_relative './model/markdown_post_provider'

class PersonalWebPage < Sinatra::Base
  enable :sessions
  helpers Sinatra::ContentFor
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

  get '/blog' do
    path = settings.root + '/' + settings.blog['source_dir'] + '/index.yml'
    collection = YAML.load_file(path)
    posts = []
    collection.each do |post_data|
      posts << Post.new(post_data[:title], nil, post_data[:date], post_data[:href])
    end
    haml :blog_index, :locals => { :index => posts }
  end

  get '/blog/:title' do |title|
    path = settings.root + '/' + settings.blog['source_dir']
    post = MarkdownPostProvider.load(title, path)
    haml :post, :locals => { :post => post }
  end
end

