class PostDecorator

  def initialize(post)
    @post = post
  end

  def method_missing(method, *args)
    args.empty? ? @post.send(method) : @post.send(method, args)
  end

  def format_date
    @post.date.strftime("%A, %d %B %Y")
  end

end