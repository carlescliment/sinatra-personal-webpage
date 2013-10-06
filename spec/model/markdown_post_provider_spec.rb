require_relative '../../model/markdown_post_provider'

describe 'MarkdownPostProvider' do


  before(:each) do
    @file = double('File', :read => 'File contents')
  end

  it "should look for a file in the specified directory" do
    url_title = 'some-title'
    path = 'path/to/posts'

    File.should_receive(:open).with('path/to/posts/some-title.md', 'r').and_return(@file)

    MarkdownPostProvider.load(url_title, path)
  end

  it "reads the file contents" do
    stub_file_read

    @file.should_receive(:read)

    MarkdownPostProvider.load('', '')
  end

  it "renders the file contents" do
    stub_file_read

    Metadown.should_receive(:render).with('File contents').and_return(metadown_results)

    MarkdownPostProvider.load('', '')
  end

  it "provides the post containing the content read" do
    stub_file_read
    render_results = metadown_results
    Metadown.stub(:render).and_return(render_results)

    post = MarkdownPostProvider.load('', '')

    expect(post.body).to eql render_results.output
  end


  it "provides the post containing the title read" do
    stub_file_read
    render_results = metadown_results
    Metadown.stub(:render).and_return(render_results)

    post = MarkdownPostProvider.load('', '')

    expect(post.title).to eql render_results.metadata['title']
  end


  it "provides the post containing the date read" do
    stub_file_read
    render_results = metadown_results
    Metadown.stub(:render).and_return(render_results)

    post = MarkdownPostProvider.load('', '')

    expect(post.date).to eql render_results.metadata['date']
  end


  private

  def stub_file_read
    File.stub(:open).and_return(@file)
  end


  def metadown_results
    metadata = {'title' => 'Some title', 'date' => '2013-10-06'}
    expected_body = 'This is a body'
    double(:output => expected_body, :metadata => metadata)
  end

end
