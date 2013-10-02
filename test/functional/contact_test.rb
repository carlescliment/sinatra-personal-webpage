require_relative '../../app'

require 'capybara'

describe 'contact' do
  include Capybara::DSL

  before do
    Capybara.app = PersonalWebPage.new
  end

  it 'Provides a link to the contact form in the profile page' do
    visit '/'

    page.should have_selector('a[href="/contact"]')
  end


  it 'Shows a contact form' do
    visit '/contact'

    page.should have_selector('form#contact')
  end

end
