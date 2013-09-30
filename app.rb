require 'sinatra'


class PersonalWebPage < Sinatra::Base
  get '/' do
    '<html><head></head><body id="profile">Hello, world!<body>'
  end
end