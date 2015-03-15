require_relative './post'
require_relative './post_decorator'

class BlogIndex

  def initialize(max_per_page = 10, current_page = 0)
    @posts = []
    @max_per_page = max_per_page
    @current_page = current_page
  end

  def load(index_file)
    collection = YAML.load_file(index_file)
    collection.each do |post_data|
      post = Post.new(post_data[:title], nil, post_data[:date], post_data[:source], post_data[:href])
      @posts << PostDecorator.new(post)
    end
  end

  def find_by_uri(uri)
    @posts.find { |post| post.href == uri }
  end

  def page_posts
    newest = @max_per_page * @current_page
    oldest = newest + @max_per_page

    @posts[newest...oldest] or []
  end

  def has_next?
    @posts.count > @current_page*@max_per_page + @max_per_page
  end

  def has_previous?
    @current_page > 0
  end

  def next_page
    @current_page + 1
  end

  def current_page
    @current_page
  end

  def previous_page
    if @current_page == 0
      return 0
    end

    @current_page-1
  end

  def pages
    if @posts == 0
      return 1
    end

    (@posts.count.to_f / @max_per_page).ceil
  end
end
