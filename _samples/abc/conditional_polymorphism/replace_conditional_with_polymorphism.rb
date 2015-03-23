require 'ostruct'

class ChildrensPrice
  def price_code
    Movie::CHILDREN
  end

  def get_charge(days_rented)
    result = 1.5
    result += ((days_rented-3) * 1.5) if (days_rented > 3)

    result
  end
end

class NewReleasePrice
  def price_code
    Movie::NEW_RELEASE
  end

  def get_charge(days_rented)
    days_rented * 3
  end
end

class RegularPrice
  def price_code
    Movie::REGULAR
  end

  def get_charge(days_rented)
    result = 2
    result += ((days_rented-2) * 1.5) if (days_rented > 2)
    
    result
  end
end

class Rental
  attr_reader :movie, :days_rented

  def initialize(movie, days_rented)
    @movie = movie
    @days_rented = days_rented
  end

  def get_charge()
    @movie.get_charge(@days_rented)
  end

  def get_frequent_renter_points()
    @movie.get_frequent_renter_points(@days_rented)
  end
end

class Movie
  REGULAR = 'R'
  NEW_RELEASE = 'N'
  CHILDREN = 'C'

  attr_reader :price_code, :title

  def initialize(title, price_code)
    @title = title
    set_price_code(price_code)
  end

  def get_frequent_renter_points(days_rented)
    if @price_code.price_code == Movie::NEW_RELEASE && days_rented > 1
      2
    else
      1
    end
  end

  def get_charge(days_rented)
    @price_code.get_charge(days_rented)
  end

  private

  def set_price_code(price_code)
    case price_code
    when Movie::REGULAR
      @price_code = RegularPrice.new
    when Movie::NEW_RELEASE
      @price_code = NewReleasePrice.new
    when Movie::CHILDREN
      @price_code = ChildrensPrice.new
    end
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
      frequent_renter_points += rental.get_frequent_renter_points
    end

    frequent_renter_points
  end
end
