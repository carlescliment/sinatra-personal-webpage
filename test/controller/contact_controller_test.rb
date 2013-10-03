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

    Pony.should_receive(:mail).with(
      :to => 'to@address.is',
      :from => 'from@address.is',
      :subject => 'Contact from your personal webpage',
      :body => "#{sender} : #{message}")

    post '/contact', params={:email => sender, :message => message}
  end


  def stub_contact_settings(from, to)
    contact_settings = {'from_address' => from, 'to_address' => to}
    app.settings.contact = contact_settings
  end
end
