require 'ostruct'

class Rental
  attr_reader :movie, :days_rented

  def initialize(movie, days_rented)
    @movie = movie
    @days_rented = days_rented
  end

  def get_charge()
    the_amount = 0
    case @movie.price_code
    when Movie::REGULAR
      the_amount += 2
      the_amount += ((@days_rented-2) * 1.5) if (@days_rented > 2)
    when Movie::NEW_RELEASE
      the_amount += @days_rented * 3
    when Movie::CHILDREN
      the_amount += 1.5
      the_amount += ((@days_rented-3) * 1.5) if (@days_rented > 3)
    end

    the_amount
  end
end

class Movie
  REGULAR = 'R'
  NEW_RELEASE = 'N'
  CHILDREN = 'C'

  attr_reader :price_code, :title

  def initialize(title, price_code)
    @title = title
    @price_code = price_code
  end
end

class Customer
  def initialize(name)
    @name = name
    @rentals = []
  end

  def rent(rental)
    @rentals << rental

    self
  end

  def statement
    total_amount = 0
    frequent_renter_points = 0
    result = "Rental record for #{@name}"
    @rentals.each do |rental|
      frequent_renter_points+=1 
      frequent_renter_points+=1 if rental.movie.price_code == Movie::NEW_RELEASE && rental.days_rented >1
      result += "\t#{rental.movie.title}\t#{rental.get_charge}"
      total_amount += rental.get_charge
    end

    result += "Amount owed is #{total_amount}.\n"
    result += "You earned #{frequent_renter_points} frequent renter points.\n"
    result
  end
end


movie = Movie.new('Blade Runner', Movie::NEW_RELEASE)
rental = Rental.new(movie, 4)
Customer.new('Carles').rent(rental).statement
