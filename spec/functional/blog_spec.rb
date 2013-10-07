require_relative '../../app'

require 'capybara'

describe 'blog' do
  include Capybara::DSL

  before do
    Capybara.app = PersonalWebPage.new
    Capybara.app.settings.blog['source_dir'] = 'spec/functional/fixtures'
  end


  it 'renders the index' do
    #see index.yml
    expected = 10

    visit '/blog'

    page.all('.post').count.should eql expected
  end


  it 'renders next pages' do
    #see index.yml
    expected = 3

    visit '/blog?page=1'

    page.all('.post').count.should eql expected
  end


  it 'renders a blog post' do
    #see test-post.md
    expected = 'This is a sample post'

    visit '/blog/test-post'

    expect(page.status_code).to be 200
    expect(page).to have_content expected
  end
end
