require_relative '../../app'

require 'capybara'
require 'test/unit'


describe "Contact" do
  include Capybara::DSL

  before do
    Capybara.app = PersonalWebPage.new
  end

  it 'shows a link to contact in the profile page' do
    visit '/'

    page.should have_selector('a[href="/contact"]')
  end


  it 'shows a contact form' do
    visit '/contact'

    page.should have_selector('form#contact')
  end


  it 'receives the contact request' do
    visit '/contact'

    page.fill_in 'email', :with => 'sample@email.is'
    page.fill_in 'message', :with => 'Hi, I just wanted to say hello'
    click_button('Send')

    page.should have_selector('.success')
  end


end
