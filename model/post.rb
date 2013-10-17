class Post
  def initialize(title, body, date, href = '')
    @title = title
    @body = body
    @date = date
    @href = href
  end

  def body
    @body
  end

  def title
    @title
  end

  def date
    @date
  end

  def href
    @href
  end

end