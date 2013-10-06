require 'rack/test'
require_relative '../../app'
require_relative '../spec_helper'

describe '/blog' do

  def app
    PersonalWebPage.new
  end

  it "should show a post" do
    title = 'some-post-title'
    path_to_posts = 'path/to/posts'
    app.settings.blog['source_dir'] = path_to_posts
    expected_path = app.settings.root + '/' + path_to_posts

    MarkdownPostProvider.should_receive(:load).with(title, expected_path)

    get "/blog/#{title}"
  end
end
