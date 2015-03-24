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
    result = "Rental record for #{@name}"
    @rentals.each do |rental|
      result += "\t#{rental.movie.title}\t#{rental.get_charge}"
    end

    result += "Amount owed is #{get_total_charge}.\n"
    result += "You earned #{get_total_frequent_renter_points} frequent renter points.\n"
    result
  end

  private

  def get_total_charge
    total_charge = 0
    @rentals.each do |rental|
      total_charge += rental.get_charge
    end

    total_charge
  end

  def get_total_frequent_renter_points
    frequent_renter_points = 0
    @rentals.each do |rental|
      frequent_renter_points += get_frequent_renter_points(rental) 
    end

    frequent_renter_points
  end

  def get_frequent_renter_points(rental)
      if rental.movie.price_code == Movie::NEW_RELEASE && rental.days_rented > 1
        2
      else
        1
      end
  end
end


movie = Movie.new('Blade Runner', Movie::NEW_RELEASE)
rental = Rental.new(movie, 4)
Customer.new('Carles').rent(rental).statement
