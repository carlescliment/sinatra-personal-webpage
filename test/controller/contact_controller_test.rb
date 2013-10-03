require_relative '../../controllers/contact_controller'
require 'rack/test'
require_relative '../spec_helper'

describe ContactController do
  let(:controller) {
    described_class.new('carles@testing.is')
  }

  it "should send an email when submitting a form" do
    sender = 'roy@batty.is'
    message = "I've seen things you wouldn't believe"

    Pony.should_receive(:mail).with(
      :to => 'carles@testing.is',
      :from => 'carles@testing.is',
      :subject => 'Contact from your personal webpage',
      :body => "#{sender} : #{message}")

    controller.send(sender, message)
  end
end
