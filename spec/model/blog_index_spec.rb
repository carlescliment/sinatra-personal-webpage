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
    posts = [{:title => 'title', :date => '2013-10-17', :href => '/blog/blah'}]
    stub_existing_posts(posts)

    Post.should_receive(:new).with(posts[0][:title], nil, posts[0][:date], posts[0][:href]);

    @index.load('index.yml')
  end


  it "brings the correct number of pages when all the pages are full" do
    posts = 30.times.collect {
      {:title => 'title', :date => '2013-10-17', :href => '/blog/blah'}
    }
    stub_existing_posts(posts)

    @index.load('index.yml')

    expect(@index.pages()).to eql(3)
  end


  it "brings the correct number of pages when the last page is not full" do
    posts = 29.times.collect {
      {:title => 'title', :date => '2013-10-17', :href => '/blog/blah'}
    }
    stub_existing_posts(posts)

    @index.load('index.yml')

    expect(@index.pages()).to eql(3)
  end

  it "decorates posts" do
    posts = [{:title => 'title', :date => '2013-10-17', :href => '/blog/blah'}]
    stub_existing_posts(posts)

    PostDecorator.should_receive(:new) do |post|
      expect(post.class).to eql Post
    end

    @index.load('index.yml')
  end



  private

  def stub_existing_posts(posts)
    YAML.stub(:load_file).and_return(posts)
  end
end
