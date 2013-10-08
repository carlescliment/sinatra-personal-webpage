require 'metadown'
require_relative './post'
require_relative '../modules/syntax_markdown'

class MarkdownPostProvider
  def self.load(url_title, path)
    contents = read_contents(url_title, path)
    renderer = Redcarpet::Markdown.new(SyntaxMarkdown, :fenced_code_blocks => true)
    markdown_data = Metadown.render(contents, renderer)
    markdown_to_post(markdown_data)
  end

  private

  def self.read_contents(url_title, path)
    full_path = path + '/' + url_title + '.md'
    File.open(full_path, 'r').read
  end

  def self.markdown_to_post(markdown)
    Post.new(markdown.metadata['title'], markdown.output, markdown.metadata['date'])
  end
end