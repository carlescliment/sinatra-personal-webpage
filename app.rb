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
              :body => "#{sender} : #{message}",
              :via => settings.mailer['transport'],
              :via_options => {
                :address => settings.mailer['host'],
                :port => settings.mailer['port'],
                :user_name => settings.mailer['username'],
                :password => settings.mailer['password']
              }

    flash.next[:info] = "Thanks, the e-mail has been sent. I'll respond to you as soon as possible. Promise!"
    redirect '/contact'
  end

  get '/blog' do
    index = load_index(settings.blog)
    haml :blog_index, :locals => { :index => index }
  end

  get '/blog/:uri' do |uri|
    index = load_index(settings.blog)
    post = load_post_or_404(index.find_by_uri("/blog/#{uri}").source, settings.blog)
    haml :post, :locals => { :post => post }
  end

  get '/publications' do
    index = load_index(settings.publications)
    haml :publications_index, :locals => { :index => index }
  end

  get '/publications/:title' do |uri|
    index = load_index(settings.publications)
    post = load_post_or_404(index.find_by_uri("/publications/#{uri}").source, settings.publications)
    haml :publication, :locals => { :post => post }
  end

  private

  def load_post_or_404(title, config)
    begin
      dir = settings.root + '/' + config['source_dir']
      PostDecorator.new(MarkdownPostProvider.load(title, dir))
    rescue
      error 404, 'Page not found'
    end
  end

  def load_index(config)
    index_file = settings.root + '/' + config['source_dir'] + '/index.yml'
    index = BlogIndex.new(config['max_per_page'], current_page)
    index.load(index_file)
    index
  end

  def current_page
    params[:page].to_i.abs or 0
  end

  not_found { haml :'404' }
  error { haml :'500' }
end
