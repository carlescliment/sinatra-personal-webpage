require_relative './../model/markdown_post_provider'
require_relative './disable_custom_markdown'


class IndexCreator

  class EntryFactory
    def initialize(base_url, sources)
      @base_url = base_url
      @sources = sources
    end

    def create(file_path)
      uri = relative_uri(file_path)
      post = load_post_from_file(uri)
      basename = File.basename(file_path, '.md')
      {
        :title => post.title,
        :date => post.date,
        :href => "#{@base_url}/#{basename}",
        :source => "#{uri}"
      }
    end

    private

    def relative_uri(file_path)
      match = Regexp.new("#{@sources}\/(.*)").match(file_path)
      match[1]
    end

    def load_post_from_file(basename)
      MarkdownPostProvider.load(basename, @sources)
    end
  end

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
    starting_char = @sources.length+1
    entry_factory = EntryFactory.new(@url, @sources)
    Dir.glob("#{@sources}/**/*.md") do |md_file|
      index << entry_factory.create(md_file)
    end

    index
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
