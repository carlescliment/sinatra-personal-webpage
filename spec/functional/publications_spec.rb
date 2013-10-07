require_relative '../../app'

require 'capybara'

describe 'publications' do
  include Capybara::DSL

  before do
    Capybara.app = PersonalWebPage.new
    Capybara.app.settings.publications['source_dir'] = 'spec/functional/fixtures'
  end


  it 'renders the index' do
    #see index.yml
    expected = 10

    visit '/publications'

    page.all('.publication').count.should eql expected
  end

  it 'renders a publication' do
    #see test-post.md
    expected = 'This is a sample post'

    visit '/publications/test-post'

    expect(page.status_code).to be 200
    expect(page).to have_content expected
  end
end
