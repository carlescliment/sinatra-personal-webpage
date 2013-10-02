# helper.rb
require 'minitest/autorun'
require 'rack/test'

require File.expand_path('../../app', __FILE__)
set :environment, :test