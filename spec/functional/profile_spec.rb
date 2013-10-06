require_relative '../../app'

require 'capybara'

describe 'profile' do
  include Capybara::DSL

  before do
    Capybara.app = PersonalWebPage.new
  end

  it 'Shows the personal profile' do
    visit '/'

    page.should have_selector('#profile')
  end
end
