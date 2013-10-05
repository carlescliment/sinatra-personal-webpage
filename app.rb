require 'sinatra'
require 'sinatra/flash'
require 'sinatra/config_file'
require 'pony'
require 'metadown'


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

  get '/blog/:slug' do |title|
    content = File.open("#{File.dirname(__FILE__)}/_posts/#{title}.md", "rb").read
    data = Metadown.render(content)
    haml :post, :locals => { :content => data.output.force_encoding('UTF-8'), :title => data.metadata['title']}
  end
end

