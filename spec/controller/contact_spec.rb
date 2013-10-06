require 'rack/test'
require_relative '../../app'
require_relative '../spec_helper'

describe '/post' do

  def app
    PersonalWebPage.new
  end

  it "should send an email when submitting a form" do
    sender = 'roy@batty.is'
    message = "I've seen things you wouldn't believe"
    stub_contact_settings('from@address.is', 'to@address.is')

    Pony.should_receive(:mail) do |params|
      params[:to].should be 'to@address.is'
      params[:from].should be 'from@address.is'
      params[:body].should include(sender)
      params[:body].should include(message)
    end

    post '/contact', params={:email => sender, :message => message}
  end


  def stub_contact_settings(from, to)
    contact_settings = {'from_address' => from, 'to_address' => to}
    app.settings.contact = contact_settings
  end
end
