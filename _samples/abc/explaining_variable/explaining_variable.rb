class ExplainingVariable
  def do(platform, browser)
    is_mac_os = !platform.capitalize.index('MAC').nil?
    is_ie_browser = !browser.capitalize.index('IE').nil?
    was_resized = resize > 0
    if is_mac_os &&
        is_ie_browser &&
        was_initialized &&
        was_resized
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
