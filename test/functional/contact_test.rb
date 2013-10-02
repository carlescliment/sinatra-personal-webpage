require_relative '../../app'

require 'capybara'

describe 'contact' do
  include Capybara::DSL

  before do
    Capybara.app = PersonalWebPage.new
  end

  it 'Provides a call-to-action in the profile page' do
    visit '/'

    page.should have_selector('#contact-link')
  end
end
