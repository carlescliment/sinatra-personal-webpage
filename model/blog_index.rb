class BlogIndex

  def initialize(max_per_page = 10, current_page = 0)
    @posts = []
    @max_per_page = max_per_page
    @current_page = current_page
  end

  def load(index_file)
    collection = YAML.load_file(index_file)
    collection.each do |post_data|
      @posts << Post.new(post_data[:title], nil, post_data[:date], post_data[:href])
    end
  end

  def posts
    newest = @max_per_page * @current_page
    oldest = newest + @max_per_page
    @posts[newest...oldest]
  end

  def has_next?
    @posts.count > @current_page*@max_per_page + @max_per_page
  end

  def has_previous?
    @current_page > 0
  end

  def next_page
    @current_page+1
  end

  def previous_page
    if @current_page == 0
      return 0
    end
    @current_page-1
  end
end