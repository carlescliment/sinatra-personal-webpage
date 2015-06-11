---
title: Why inheritance?
date: 2015-06-12
---

### Introduction

It all started in a code review, when a new optional parameter in a superclass method caught my eye. The change was very small, and it affected a code written three years ago that had remained untouched for long. Apart from that small change in the superclass, the Pull Request also introduced some other changes, particularly in a few of the subclasses. The new code was okay, but there was that little optional parameter and a conditional crying for attention.


```ruby
## Optional parameter

class Cooker
  def initialize(pan)
    @pan = pan
  end

  def cook_omelette(add_potatoes=false)
    @pan << Eggs
    @pan << Potatoes if add_potatoes
    @pan.fry
    @pan.serve
  end
end

class FrenchCooker < Cooker
  def make_dish
    cook_omelette
  end
end

class SpanishCooker < Cooker
  def make_dish
    cook_omelette(true)
  end
end
```

Obviously this is not the kind of code we write at work, but I hope it helps to understand the situation. The subclasses were passing an optional parameter because they needed a different behaviour from the superclass. That was very confusing and an approach to inheritance that incstinctively I knew was wrong. Not only because a flag parameter is a bad smell by itself, indeed it wasn't a flag in the actual code, but because of how the inheritance was being perverted.

Anyway, I put a comment in the PR and went back to my stuff, but that morning the inheritance problem digged so deep into my mind that in the afternoon I was still thinking about it, discussing it with my coworkers and ranting against inheritance from my Twitter account. Then I decided to consolidate my ideas and write a blog post. I also realised that many of my writings have been written against things, so I decided to reverse the perspective and, instead of ranting against inheritance, try be constructive and to explain when to use it properly from my understanding.

There we go.


### When to use inheritance

Inheritance is not necessarily bad. It was created for good reasons and, for sure, it has good uses. I must admit I VERY rarely use inheritance, but in some situations it can be very worth to use this extension mechanism.

#### Specialization

With specialization, we create a superclass and provide methods to allow points of extension. Ideally, the superclass should be abstract and the extension point should be very clear to clients. The specialization should consist on a single responsibility. That way we will have a consistent relationship between the hierarchy and the varying context. This is what some programmers call 'Single Segregated Responsibility'. It is importante to notice that the abstract classes should "rule" the behaviour while the subclasses are just supposed to introduce variations in it.

A well known case of specialization is the [Form Template Method Pattern](http://www.refactoring.com/catalog/formTemplateMethod.html). Specialization is also strongly related to polymorphism.

#### Polymorphism

With polymorphism, we write two or more implementations of the same interface. Then, those implementations are provided to client classes who are completely agnostic about them and only know about the common interface. This is a powerful concept that lets us build dynamic aplications with different behaviours on execution time. It also enforces the "program to an interface, not to an implementation" principle, which in the end helps us to keep our code decoupled.

It can be implemented both with inheritance and with composition/aggregation, depending on our preferences and needs.

Polymorphism is heavily related to the [Liskov Substitution Principle](http://c2.com/cgi/wiki?LiskovSubstitutionPrinciple), which redunds in the idea of the abstraction of specific implementations.


#### Generalization

Generalization is the reverse to specialization. It consists of the discovery of hierarchies from the existing classes. The goal of generalization should be the same as the specialization, it is, favour the use of abstractions over implementations.

Generalization is, in my opinion, the root of all evil when talking about inheritance, and it is in my opinion because abstraction or polymorphism is almost never the motivation for extracting a superclass. Instead, we are often tempted to do so in order to reuse code. We will talk about it in the next section.


### When not to use inheritance

#### Stupid DRY

We all know the "Don't Repeat Yourself" ([DRY](http://en.wikipedia.org/wiki/Don%27t_repeat_yourself)) principle. Although it is undoubtedly a good principle, it can turn against ourselves when followed blindly:


```
# No generalization

class DwarvenWarrior
  def initialize(hammer)
    @hammer = hammer
  end
 
  def bash(something)
    # implementation ...
  end
end

class HouseBuilder
  def initialize(hammer)
    @hammer = hammer
  end
 
  def bash(something)
    # implementation ...
  end
end
```

In the example above we can see a replicated method `initialize` being used in both classes. Anyone could be tempted to extract a superclass to contain the constructor. After all, they even share the same interface, right?

```
# Generalization

class Hammerer
  def initialize(hammer)
    @hammer = hammer
  end

  def bash
    raise 'To implement in a subclass'
  end
end

class DwarvenWarrior < Hammerer
  def bash(something)
    # implementation ...
  end
end

class HouseBuilder < Hammerer
  def bash(something)
    # implementation ...
  end
end
```

We use to think that generalization comes at zero cost, but it isn't true. When we extract a superclass, we bind all the subclasses together in the same hierarchy. Inheritance adds coupling, and that coupling can bring design problems if not chosen carefully. Whenever you're about to create a superclass, please think about the reasons we talked about in the previous section. The new abstraction `Hammerer` can make sense or not. In the context of building houses, we may need the help of a HouseBuilder, but we won't probably want a DwarvenWarrior bashing on things all around. Always evaluate if those subclases can be replaced meaningfully in the clients using them. Again we must refer to the Liskov Substitution Principle.


#### Who works for whom?

As we talked before, good superclasses have one, and only one, abstract method to override. I've taken this idea (or at least that is my interpretation) from Xavi Gost, who used the term 'Single Segregated Responsibility'. The subclass is then responsible to do one thing: specializing the superclass.

But often what we find is the reverse. The superclass contains a bunch of methods that are used by the subclasses, so the superclass becomes a toolbox, a servant. As we add more and more of the subclasses, some of the methods in the superclass aren't even used by the majority of the subclasses.

We may even introduce intermediate superclasses to contain those methods, creating a hierarchy motivated by the replication of the code instead of by meaningful abstractions. When this happens, it may be the time to rethink our design.

#### Parents don't change, children do

Let's go back to the example that introduced this blog post, the optional parameter in a superclass method. This change was motivated because two subclasses were calling the parent method but they needed different behaviours from it. This is a clear violation of the previous section. Subclasses weren't serving the superclass, but the superclass was the servant of the subclasses. Also, it introduces some knowledge in the superclass that shouldn't be there, since it is now aware of the different behaviours it needs to provide to its subclasses.

If you need to change a superclass because you implemented or modified a subclass, your design may be flawed.

#### It's all about abstraction

Inheritance is about abstraction. If we follow the Liskov principle and make our subclases replaceable with each other, we have a powerful tool to make our app behave in different ways in runtime. But sometimes the abstractions we have created are never used. Clients always know what specific implementation to use. No polymorphism. No "program for interfaces, not for implementations".

For each hierarchy in your system, look at the clients using it. If they are treating the objects as mere abstractions (if they expect to receive the superclass), very likely the way you implemented inheritance is legit. On the other hands, if the clients expect to receive (or if they instantiate) a concrete implementation, you could have better go for composition.

### Conclusions

My goal for this post was to clarify my thoughts about inheritance. I've tried to keep myself focused on it, and to resist the temptation to talk about composition. I'd like to have written more code examples, or at least more realistic ones. I must admit I find it very hard to invent appropriate examples. I hope to have expressed my ideas clearly at least.

I've also collected a bunch of the smells I use to identify "bad inheritance". There are many other smells out there, for sure, those are the ones that have came up to my mind. I hope you find them useful in your day-to-day work.

Thanks for reading.
