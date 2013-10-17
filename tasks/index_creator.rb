require_relative './../model/markdown_post_provider'
require_relative './disable_custom_markdown'


class IndexCreator

  def initialize(sources, url)
    @sources = sources
    @url = url
  end

  def create()
    index = build()
    sort(index)
    save(index)
  end


  private

  def build()
    index = []
    Dir.glob("#{@sources}/*.md") do |md_file|
      basename = File.basename(md_file, ".md")
      post = load_post_from_file(basename)
      index << { :title => post.title, :date => post.date, :href => "#{@url}/#{basename}#disqus_thread" }
    end
    index
  end

  def load_post_from_file(basename)
      MarkdownPostProvider.load(basename, @sources)
  end


  def sort(index)
    index.sort! { |a,b| b[:date] <=> a[:date] }
  end

  def save(index)
    File.open("#{@sources}/index.yml", "w") do |file|
      file.puts YAML::dump(index)
    end
  end
end