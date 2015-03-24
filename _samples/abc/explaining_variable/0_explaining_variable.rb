class ExplainingVariable
  def do(platform, browser)
    if (!platform.capitalize.index('MAC').nil?) &&
        (!browser.capitalize.index('IE').nil?) &&
        was_initialized &&
        resize > 0
      do_something
    end
  end

  def was_initialized
  end

  def resize
  end

  def do_something
  end
end
