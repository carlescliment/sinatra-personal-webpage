class Printer
  def print_owning(amount)
    print_banner
    print_details(amount)
  end

  def print_banner
    #prints the banner
  end

  def print_details(amount)
    puts 'The name'
    puts 'The amount '+amount.to_s
  end
end
