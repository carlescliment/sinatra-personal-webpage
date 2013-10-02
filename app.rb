require 'sinatra'
require 'sinatra/flash'

class PersonalWebPage < Sinatra::Base
  enable :sessions
  register Sinatra::Flash

  get '/' do
    haml :profile, :format => :html5
  end

  get '/contact' do
    haml :contact, :format => :html5
  end

  post '/contact' do
    flash.next[:info] = "Thanks, the e-mail has been sent. I'll respond to you as soon as possible. Promise!"
    redirect '/contact'
  end
end

