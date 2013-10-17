require_relative '../../model/blog_index'

describe 'BlogIndex' do

  before(:each) do
    @index = BlogIndex.new
  end


  it "brings an empty collection on unexisting pages" do
    posts = @index.page_posts

    expect(posts).to eql []
  end


  it "creates posts from index entries" do
    existing_post = stub_existing_post

    Post.should_receive(:new).with(existing_post[:title], nil, existing_post[:date], existing_post[:href]);

    @index.load('index.yml')
  end


  it "decorates posts" do
    stub_existing_post

    PostDecorator.should_receive(:new) do |post|
      expect(post.class).to eql Post
    end

    @index.load('index.yml')
  end



  private

  def stub_existing_post
    existing_post = { :title => 'title', :date => '2013-10-17', :href => '/blog/blah' }
    file_contents = [existing_post]
    YAML.stub(:load_file).and_return(file_contents)
    return existing_post
  end
end
