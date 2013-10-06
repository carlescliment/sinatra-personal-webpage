require 'pony'

def do_not_send_email
  Pony.stub(:deliver)  # Hijack deliver method to not send email
end

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
  conf.mock_with :rspec

  conf.before(:each) do
    do_not_send_email
  end
end