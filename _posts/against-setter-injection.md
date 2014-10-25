---
title: Against setter injection
date: 2014-10-25
---

> **Disclaimer:** This blog post reproduces fragments of the book "[The Art of Unit Testing](http://www.manning.com/osherove/)", which is protected by copyright. Thus, I'm publishing it with the express authorization of the author, [Roy Osherove](http://osherove.com/). Lots of thanks to him for his early response, kindness and understanding.

> **Disclaimer II:** By the time Roy wrote his book in 2009, I knew almost nothing about testing. Testing was, for me, no more than checklists written by hand and a bit of automation with Selenium. During that times, he was an experienced architect, developer and consultant. Roy is far more experienced than me in the matter and it is far from my intention to flame, blame or disregard him. Software development, and testing in particular, is a field of knowledge in constant change and revision. While we as developers evolve with it, the things we wrote stay the same. It'd be easy for anyone to take any of my older posts and write lots of arguments against it. Probably it is easy to do so with this one. I challenge you! ;)

> **Disclaimer III:** I mention TDD many times in the post. Roy makes it clear that his book is not about TDD. Anyway, the test-first approach is, for me, the best way to achieve testable code and good design. As I've said many times to friends, TDD has had the deepest impact in my professional life, and that's why all I wrote is heavily influenced by its perspective.


One of the first chapters of _"The Art of Unit Testing"_ describes what a stub is and introduces the concept of dependency injection. The author presents three ways of injecting dependencies:

* Via constructor.
* As an argument of the method that needs the collaborator.
* Via setter.

When talking about constructor injection, he writes the following:

> Adding more and more constructors, or more and more constructor parameters, becomes a hassle, and it can make the code less readable and less mantainable.

And

> My experience is that using constructor arguments to initialize objects can make your testing code more cumberstone unless you're using [...] IoC containers for object creation. Every time you add another dependency to the SUT you need to add a new constructor and make sure other users of the class initialize it with the new constructor.

He seems to advocate for setter injection:

> In this scenario, we add a property get and set for each dependency we'd like to inject. Using this technique, [...] our test code [...] is more readable and simpler to achieve."



Although the book is full of good advices, I cannot agree with this particular one. I think that the book is missing some important points:

1. When you add _more and more_ dependencies in construction, it's not the test what you've to solve. A class that has too many dependencies is a class that does too many things. When you feel the pain in the test, that pain is caused by a poor design.

2. IoC containers are not meant to be used as factories. Quoting the author of the book, _"there is no problem in OOP that cannot be solved with an additional layer of indirection, except too many indirection"_. Any IoC container adds LOADS of indirection, as I described in a previous post [Usos y abusos del DIC](/blog/usos-y-abusos-del-dic) (In spanish, sorry) so they should be used wisely, mostly when we need to inject different implementations depending on the environment conditions. Furthermore, using the IoC as a mighty factory makes your business logic framework-dependent, thus adding testability and portability problems.

3. When it becomes a pain to change a constructor because there are lots of clients instantiating it, it is an evidence of the spreading of construction logic. Once we get to that point, it is clear that we missed some refactorings in our TDD process. As soon as the number of clients instantiating a class goes off your hands, centralize the construction logic by using factories or builders.

4. _"Simpler to achieve"_ doesn't always mean _"simpler to mantain"_. There are lots of test and mock frameworks that put many efforts in making things easier to achieve. Sometimes, these frameworks are hidding design problems by hidding the smells. Feeling the pain while testing is the essence of TDD, since it is the way you receive the feedback, the light that guides your refactorings.

In contrast, I find the setter injection very dangerous. By letting clients modify your internal structure, you're exposing it to them. Clients shouldn't care about the internal dependencies of the classes they're using, they should care only about the behavior. Other problem is that, the more clients using the setter injection, the harder you'll refactor the code. How will you remove a dependency from a class, if there are tens of clients that assume that the dependency exists? What about the "program to interfaces" principle? By providing ways to change the internal collaborators, aren't we thinking about concrete implementations?

I'm sure there are more inconveniences to setter injection, like mutability. One client could set an implementation and assume it will stay. What if, later, another client sets a different one? Unexpected behaviours could arise, unexpected and really hard to debug. One might argue that setter injection is intended to be used only for testing, but the fact is that we are opening dangerous gates. Guns don't necessarily have to be fired just because they exist. Anyway, I prefer not having a gun on my desk.

Another reason for writing setter injectors is to provide the classes with optional collaborators. For instance, a class could optionally have a logger:

```python
class Mailer:
  
  def __init__(self):
    self.logger = None

  def set_logger(self, logger):
    self.logger = logger

  def send(self, email):
    # do stuff
    if self.logger:
      self.logger.log('An email has been sent')
```

By doing so we are breaking the Single Responsibility Principle and introducing flaws expressed by conditional logic. There are other ways to provide more features to a class, such as decorator, observer or mediator, among others. Optional collaborators tend to grow and can damage the design of the apps seriously if they're used profusely.

Summarizing, listening to the tests is fundamental in TDD. A problem in a test is, almost ever, a problem in the design. By implementing quick-fixes such as setter injection to make things easier to achieve, we are not only leaving the problems unresolved, but also creating new design flaws.

