require 'sinatra'
require 'sinatra/flash'
require 'sinatra/config_file'
require "sinatra/content_for"
require 'pony'

require_relative './model/markdown_post_provider'
require_relative './model/blog_index'

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
    index_file = blog_dir + '/index.yml'
    index = BlogIndex.new(settings.blog['max_per_page'], current_blog_page)
    index.load(index_file)
    haml :blog_index, :locals => { :index => index }
  end

  get '/blog/:title' do |title|
    post = MarkdownPostProvider.load(title, blog_dir)
    haml :post, :locals => { :post => post }
  end


  private

  def blog_dir
    settings.root + '/' + settings.blog['source_dir']
  end

  def current_blog_page
    params[:page].to_i or 0
  end
end

