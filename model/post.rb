class Post
  attr_reader :title, :body, :date, :source, :href

  def initialize(title, body, date, source, href = '')
    @title = title
    @body = body
    @date = date
    @source = source
    @href = href
  end
end
