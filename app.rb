require 'sinatra'
require 'better_errors'

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = Dir.pwd
end

class PersonalWebPage < Sinatra::Base
  get '/' do
    haml :profile, :format => :html5
  end

  get '/contact' do
    haml :contact, :format => :html5
  end
end

