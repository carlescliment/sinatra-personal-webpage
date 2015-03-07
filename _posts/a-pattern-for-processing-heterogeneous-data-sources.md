---
title: A pattern for processing heterogeneous data sources
date: 2015-03-07
---


### Introduction

Processing files and other data sources is a common issue in software development. Batch processing financial operations or enabling communication between systems and their stakeholders are just a couple of examples of it. If you're a developer it is very likely you will have to deal with massive input sources, validate them, filter the content and process it to satisfy the business needs.

In this article we will see how to refactor a hardly scalable procedural piece of code into a set of components with well defined responsibilities, easier to extend and cheaper to maintain.

The code you're going to see here is quite simple. I wouldn't recommend to apply the techniques described here for such a simple case, but keeping the problem small will help me to keep focused in the solution and discard irrelevant noise. So, please, I want you to envision the large scale.

If you want more detailed information about the refactors made, please look at the [list of commits in Github](https://github.com/carlescliment/Katas/compare/62d647df251046b3aca54220f3c91edf937eff74...175b7f287c992590caa4eae6e09d22c7da374cfe).


### Applying the pattern

#### The starting point

Look at the following code:


```
# Original version

module Loader
  def self.load(path)
    entries = []
    CSV.foreach(path) do |row|
      entries << OpenStruct.new({
        name: row[0].strip,
        balance: row[1].to_f,
        account_number: row[2]
      }) if row[1] =~ /[0-9]+\.[0-9]{2}/
    end

    entries
  end
end
```

This small piece of Ruby code is doing a bunch of things. It is reading a CSV file and creating instances with bank account information. It also discards rows where the balance is not numeric, and also processes the rest of the fields by manipulating the content, this is, it removes trailing spaces in the name and converts the balance to float. By the way, I realise that the regular expression does not allow negative balances. For the sake of the readability of this whole post let's assume that it is always positive.

Lots of different concerns are mixed together. If we left this piece of code evolve the way it is written, we would probably find more and more conditionals and manipulations in it. We are going to separate some of these responsibilities by using object oriented refactoring techniques.

#### Extract the balance validation

Our first step will be to move the validation step to another place. We'll do this by extracting a class to represent the field containing the balance, and then we'll move the validation there.

```
# extract the balance validation

module Loader
  module Fields
    class Balance
      def valid?(value)
        value =~ /[0-9]+\.[0-9]{2}/
      end
    end
  end

  def self.load(path)
    entries = []
    CSV.foreach(path) do |row|
      balance = Fields::Balance.new
      entries << OpenStruct.new({
        name: row[0].strip,
        balance: row[1].to_f,
        account_number: row[2]
      }) if balance.valid?(row[1])
    end

    entries
  end
end
```

With this extraction we've added more code and it doesn't seem easier to understand, right?. Lets keep working on it.

#### Extract the balance manipulation

Now that we have we have that new `Fields::Balance` class, we're going to put more behaviour on it. Let's make it responsible for casting the content to float.


```
# extract the balance manipulation

module Loader
  module Fields
    class Balance
      def extract(value)
        value.to_f 
      end

      def valid?(value)
        value =~ /[0-9]+\.[0-9]{2}/
      end
    end
  end

  def self.load(path)
    entries = []
    CSV.foreach(path) do |row|
      balance = Fields::Balance.new
      entries << OpenStruct.new({
        name: row[0].strip,
        balance: balance.extract(row[1]),
        account_number: row[2]
      }) if balance.valid?(row[1])
    end

    entries
  end
end
```

Uh, that means four lines more and zero readability gain. Are you sure of what  are you doing, Carles?. Patience, I beg you.

#### Extract a name field

Let's do the same we did with the balance field for the name.

```
# extract the name field

module Loader
  module Fields
    class Balance
      # ...
    end

    class Name
      def extract(value)
        value.strip
      end

      def valid?(value)
        true
      end
    end
  end

  def self.load(path)
    entries = []
    CSV.foreach(path) do |row|
      name = Fields::Name.new
      balance = Fields::Balance.new
      entries << OpenStruct.new({
        name: name.extract(row[0]),
        balance: balance.extract(row[1]),
        account_number: row[2]
      }) if balance.valid?(row[1])
    end

    entries
  end
end
```

You'll notice that the Name class has a useless `valid?` method that always returns true. It is not that useless, it keeps the consistence with the Field public interface. It also makes it easy for the future to add complex validations or content processing.

That makes 38 lines of code, 25 more than the original version and a little gain in maintainability. Let's keep moving.

#### Extract the account field

```
# extract the account field

module Loader
  module Fields
    class Balance
      # ...
    end

    class Name
      # ...
    end

    class AccountNumber
      def extract(value)
        value
      end

      def valid?(value)
        true
      end
    end
  end

  def self.load(path)
    entries = []
    CSV.foreach(path) do |row|
      name = Fields::Name.new
      balance = Fields::Balance.new
      account_number = Fields::AccountNumber.new
      entries << OpenStruct.new({
        name: name.extract(row[0]),
        balance: balance.extract(row[1]),
        account_number: account_number.extract(row[2])
      }) if balance.valid?(row[1])
    end

    entries
  end
end
```

Finally we are done with the fields. There is a consistent, although verbose way to handle the fields in the file. But we still have a long road to walk before making the code better than it was.

#### Making the row the unit of work


The code above validates each field one by one, in this step we're going to change it and apply the validation to the entire line. We'll do that with a simple refactoring technique: Extract Method.


```
# validate entire rows

module Loader
  module Fields
    # ...
  end

  def self.load(path)
    entries = []
    CSV.foreach(path) do |row|
      name = Fields::Name.new
      balance = Fields::Balance.new
      account_number = Fields::AccountNumber.new
      if self.row_valid?(row)
        extracted_fields = {
          name: name.extract(row[0]),
          balance: balance.extract(row[1]),
          account_number: account_number.extract(row[2])
        }
        entries << OpenStruct.new(extracted_fields)
      end
    end

    entries
  end

  def self.row_valid?(row)
    layout = [
      Fields::Name.new,
      Fields::Balance.new,
      Fields::AccountNumber.new
    ]
    layout.zip(row).all? do |field, value|
      field.valid?(value)
    end
  end
end
```

You'll see that I've replicated the construction of the field instances. I will understand that you give up at this point and stop reading this article. If you are still here, I must tell you this is going to get even worse.

#### Extract fields by row

Now we are going to operate the extraction considering the full row, instead of doing it field by field, the same way we did with the validation in the previous step. In order to do this, we need to add a bit more stuff to the fields classes.


```
# extract entire rows

module Loader
  module Fields
    class Balance
      def id
        :balance
      end

      # ...
    end

    class Name
      def id
        :name
      end

      # ...
    end

    class AccountNumber
      def id
        :account_number
      end

      # ...
    end
  end

  def self.load(path)
    entries = []
    CSV.foreach(path) do |row|
      if self.row_valid?(row)
        entries << OpenStruct.new(extract_fields(row))
      end
    end

    entries
  end

  def self.row_valid?(row)
    layout = [
      Fields::Name.new,
      Fields::Balance.new,
      Fields::AccountNumber.new
    ]
    layout.zip(row).all? do |field, value|
      field.valid?(value)
    end
  end

  def self.extract_fields(row)
    layout = [
      Fields::Name.new,
      Fields::Balance.new,
      Fields::AccountNumber.new
    ]

    fields = {}
    layout.zip(row).each do |field, value|
      fields[field.id] = field.extract(value)
    end

    fields
  end
end
```

We have added an `id()` method to the field classes that give us semantics to build the hash for the OpenStruct. We have moved the extraction to a method, in a way similar to the validation. And we have introduced clear replication we can start working on with.


#### Extract a Layout class

```
# extract Layout class

module Loader
  module Fields
    # ...
  end

  class Layout
    HEADERS = [
      Fields::Name.new,
      Fields::Balance.new,
      Fields::AccountNumber.new
    ]

    def valid?(row)
      HEADERS.zip(row).all? do |field, value|
        field.valid?(value)
      end
    end

    def extract(row)
      fields = {}
      HEADERS.zip(row).each do |field, value|
        fields[field.id] = field.extract(value)
      end

      fields
    end
  end

  def self.load(path)
    entries = []
    layout = Layout.new
    CSV.foreach(path) do |row|
      entries << OpenStruct.new(layout.extract(row)) if layout.valid?(row)
    end

    entries
  end
end
```

Our code is now 79 lines long while the original one was 13. But we have extracted some of the responsibilities in the `load()` method. With the separation of concerns the readability has improved significantly, but we can still improve the code.

#### Extract CSVSource class

The title of this post contains the word `heterogeneous` for a good reason. One of the strengths of the pattern I'm developing here is that it will make it easier to switch between different data sources: CSV, XML, XLS, Databases or remote services. First, we'll need an abstraction to let us build a common interface shared among these different sources.

```
# extract CSVSource class

module Loader
  module Fields
    # ...
  end
  
  class Layout
    # ...
  end
  
  class CSVSource
    def initialize(path)
      @path = path
    end

    def rows
      CSV.read(@path)
    end
  end

  def self.load(path)
    entries = []
    layout = Layout.new
    rows = CSVSource.new(path).rows
    rows.each do |row|
      entries << OpenStruct.new(layout.extract(row)) if layout.valid?(row)
    end

    entries
  end
end
```

There is something to notice here. The `load()` method asks the `CSVSource` for the rows, and then it passes them to the layout. So it is only mediating between both classes. Unless it is obviously beneficial, I try to avoid these situations by removing the mediation and making the classes talk to each other directly.

#### Break the mediation

```
# implement the crawl method

module Loader
  module Fields
    # ...
  end
  
  class Layout
    def crawl(source)
      entries = []
      source.rows.each do |row|
        entries << OpenStruct.new(extract(row)) if valid?(row)
      end

      entries
    end

    private
    
    # ...
  end
  
  class CSVSource
    # ..
  end

  def self.load(path)
    layout = Layout.new
    source = CSVSource.new(path)
    layout.crawl(source)
  end
end
```



### Using heterogeneous data sources

Once the pattern is implemented, it is really easy to switch to use different data source without changing a single line of code. Let's say that a second customer, another bank maybe, wants us to access to their database instead of sending us the file. Given that we have an abstraction for data sources, we can write the database equivalent for the CSVSource.

```
module Loader
  class DatabaseSource
    def rows
      rows = @connection.execute('SELECT * FROM `transfers`')
      sort_rows_for_layout
    end
  end

  def self.load(path)
    layout = Layout.new
    source = DatabaseSource.new(path)
    layout.crawl(source)
  end
end
```

The only thing we have to worry about is the order of the columns in the matrix provided by the `rows()` method. They must be compatible with the headers specified in the `Layout` class. This shared knowledge is one of the weaknesses of this pattern, since every time you need to change the Layout, you've to modify all the data sources to match the changes. When talking about patterns there are always tradeoffs.

### What this pattern is not

The main target of this pattern is to separate concerns. On one side we decouple the concrete artefact that will give us the data. Then there is the layout, then the validation and manipulation of the fields, then the resulting objects construction. How these objects are consumed by the system is out of the scope.

No business logic should be found in the components described in this post. The layout is not responsible for interpreting the relations between the data. For example, if some columns are related, if for some reason some operation should be applied between two cells in a row, it must be done elsewhere. If the rows must be grouped by some criteria, it is someone else who should be in charge of that.

### Problems

We commented above that there is a problem with the shared knowledge about the order of the fields between the `Layout` and the DataSource. Apart from that, the field objects have two different responsibilities: they not only clean the data they provide, but they also perform validation. There are probably better ways for doing this. I'm open to suggestions and will be happy to receive feedback from you.

Another thing to note is that you don't necessarily need that much granularity for the field classes. Let's imagine a layuot that contains two float fields, you could write a generic `FloatField` that receives the id in construction:

```
# generic fields

class FloatField
  attr_reader :id
  
  def initialize(id)
    @id = id
  end
  
  def valid?(value)
    # ...
  end
  
  def extract(value)
    # ...
  end
end


headers = [
  FloatField.new(:balance),
  FloatField.new(:interest_rate),
  # ...
  ]
```

### Note for Ruby ninjas

I'm relatively new to the Ruby language so if you're an expert Ruby programmer you'll surely know better ways to process arrays and stuff like that. Don't hesitate to send me any [Pull Request](https://github.com/carlescliment/sinatra-personal-webpage/blob/master/_posts/a-pattern-for-processing-heterogeneous-data-sources.md) with improvements to the examples.