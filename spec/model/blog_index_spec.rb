require_relative '../../model/blog_index'

describe 'BlogIndex' do
  it "brings an empty collection on unexisting pages" do
    index = BlogIndex.new(10, 10)

    posts = index.page_posts

    expect(posts).to eql []
  end
end
