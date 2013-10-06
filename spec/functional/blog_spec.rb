require_relative '../../app'

require 'capybara'

describe 'blog' do
  include Capybara::DSL

  before do
    Capybara.app = PersonalWebPage.new
    Capybara.app.settings.blog['source_dir'] = 'spec/functional'
  end

  it 'renders a blog post' do
    #see test-post.md
    expected = 'This is a sample post'

    visit '/blog/test-post'

    expect(page.status_code).to be 200
    expect(page).to have_content expected
  end
end
