require 'sinatra'
require 'sinatra/flash'
require 'pony'
$LOAD_PATH << 'controllers'
require 'contact_controller'


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
    controller = ContactController.new('noreply@carlescliment.com')
    controller.send(params[:email], params[:message])
    flash.next[:info] = "Thanks, the e-mail has been sent. I'll respond to you as soon as possible. Promise!"
    redirect '/contact'
  end
end

