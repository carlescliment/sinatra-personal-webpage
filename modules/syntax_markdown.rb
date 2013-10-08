require 'pygments'

class SyntaxMarkdown < Metadown::Renderer
  def block_code(code, language)
    Pygments.highlight(code, :lexer => language, :options => { :linenos => false })
  end
end