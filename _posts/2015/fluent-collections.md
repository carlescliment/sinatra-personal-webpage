---
title: Fluent collections
date: 2015-03-17
---

### Introduction to fluent interfaces

Odds are you have heard about *fluent interfaces* before. No worries if you haven't, you do know about them, but if you want a deep read go to [Fowler's article](http://martinfowler.com/bliki/FluentInterface.html) and refresh your knowledge. In essence, fluent interfaces are a style of programming aimed to make code more readable, more semantic and resemble more closely to the underlying domain.

A common usage for fluent interfaces is in mock frameworks, as we can see in the following PHPUnit snippet.

```php
# PHPUnit mocks

$repository = $this->getMock('Repository', ['find']);
$repository->expects($this->once)
  ->method('find')
  ->with($the_id)
  ->will($this->returnValue(false));
```

Another good use for fluent interfaces is builders.

```ruby
# Fluent builder in Ruby

vehicle = VehicleBuilder.new.
  with_brand('Seat').
  with_model('Panda').
  having_kilometers(40_000).
  aged(12).
  build
```
  
Today I want to talk about a misused case of fluent interface: fluent collections.


### Fluent collections

It is very common to find snippets of code like the following one:

```ruby
# Primitive looping

trips.each do |trip|
  if trip.from == 'VLC' && trip.to == 'NYC'
    trip.cancel!
    trips_repository.save(trip)
  end
end
```

The code above can be rewritten in a fluent style as follows:

```ruby
# Fluent collection

trips.from('VLC').to('NYC').cancel!.save_with(trips_repository)
```

As you can see, the resulting code isn't far from plain English. But there are more beneficial side effects. The most important of it is **encapsulation**. Having mere arrays or hashes and making the clients loop over them forces the clients to know about the items they are manipulating. For instance, if there are 10 places accessing `trip.from`, that means 10 places to change if that attribute changes. Apart from encapsulation, by extracting small methods to the collection we have improved the **reusability** of our code.

There are disadvantages, of course. While the first version was iterating over the elements just once, in the second version it is iterating four times. There is always a tradeoff, but when talking about performance, the tradeoff gets smaller. Unless there is evidence that our collections are going to be big enough to have a significant impact in the system usability, performance is usually a good candidate to sacrifice on the altar of clean code.

Back to the collection, I would like you to have a deeper look at it. Can you identify the different kinds of things is it doing? I'd say three.

The first two methods, `from` and `to`, are **filtering**. They return a subset of the original collection matching the selected criteria.
Then the `cancel!` method is **acting on** the whole resulting collection. The API of the collection gets polluted with the API of the underlying elements, thus implementing a kind of [Composite](http://en.wikipedia.org/wiki/Composite_pattern). Patterns are often best served together, and this interface pollution is a good one IMO. If the underlying items are [Value Objects](http://martinfowler.com/bliki/ValueObject.html), the collection would return a brand new set of instances instead of modifying the existing ones.
Finally, the `save_with` method is **providing the underlying items to the collaborator** to save them.


### Controversy

Some people don't feel comfortable with the *provide to others* feature of the collection, because it makes the collections know about system interactions. Why should a Collection know about persisting objects? While filtering or acting on the items seems logical for a collection, giving them the ability to deal with collaborators seems controversial. For those cases, some programmers like to expose the items to make the collection iterable, either by implementing iterator methods or by making the contained items public.

```ruby
# Exposing the collection

cancelled_trips = trips.from('VLC').to('NYC').cancel!
cancelled_trips.items.each do |trip|
  trips_repository.save(trip)
end
```

My problems with the solution described above are diverse. First, we are violating the encapsulation we had previously. We wrote some alias for `select` and `map`, but for all the rest we want to treat the collection as if it was an array, we want to make it iterable. And since it is iterable, we probably want to add a `count` method. And a `[]` accessor. And why not, weeks later, a `find`, `include?` and `delete`. In the end we may decide that instead of being like an array it could actually be an array.

```ruby
# ArrayCollection

class Trips << Array
  # ...
end
```

So we finally couple our Trips collection to a concrete implementation. Since we have exposed the class and given up on the [Tell don't ask principle](https://pragprog.com/articles/tell-dont-ask), we need to make a big effort to make the code evolve. Let's say we want to write a more perfomant version of the collection in which the items are stored in two hashes keyed by `from` and `to`. Man, we screwed it up.

Collections are more than simple containers. In fact, collections aren't containers at all, they are abstractions that represent sets of elements in our domain logic. So my point here is, why do you need to count? Why do you need to access to a concrete index? Why do you need to `each` the collection? What the hell you want to do, mate?

Go tell, don't ask.
