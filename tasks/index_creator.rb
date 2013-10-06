require_relative './../model/markdown_post_provider'

class IndexCreator

  def initialize(path)
    @path = path
  end

  def create()
    index = build()
    save(index)
  end


  private

  def build()
    index = []
    Dir.glob("#{@path}/*.md") do |md_file|
      post = load_post_from_file(md_file)
      index << { :title => post.title, :date => post.date }
    end
    index
  end

  def load_post_from_file(file)
      basename = File.basename(file, ".md")
      MarkdownPostProvider.load(basename, @path)
  end

  def save(index)
    File.open("#{@path}/index.yml", "w") do |file|
      file.puts YAML::dump(index)
    end
  end
end