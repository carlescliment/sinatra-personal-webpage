---
title: The test pyramid
date: 2014-06-03
---


### The test pyramid

It has been said many times that your test suite should look like a pyramid, with the end-to-end tests at the top and the unit tests at the bottom. In other words, you should write far more unit tests than acceptance/functional. There are lots of advantages to this recommendation, your tests will be faster, stronger and easier to change. For a deeper description of the concept, please visit [the post by Martin Fowler](http://martinfowler.com/bliki/TestPyramid.html). Can't disagree with what he says, but there is something I dislike: it has been taken as an unbreakable law.


During the last years I've been very concerned about my own tests and their morphology, looking at how they moved towards slow tests in detriment of faster. Was I doing it wrong? I'm sure that I was most of the times, but thinking deeper about that I've come to think that we are simplifying the matter too much. May be I shouldn't take that pyramid model in the unflexible way I do, so I've developed my own model which is not a pyramid anymore.


### The test cone

The ratio of unit and functional tests depends, of course, on the application you are writting. There are at least two factors involved: the width of the system (how many entry points it has or how many features) and the complexity of the business model. The diameter of the cone base depends on the first factor. The height of it, on the second.

![The cone of tests](/images/pyramid_of_tests_06_2014/cone-resized.jpg)

Given that, a heavy-CRUD application with lots of administration tasks could look like a chinese hat.

![The cone of tests as a chinese hat](/images/pyramid_of_tests_06_2014/cone-wide-resized.jpg)

In contrast, a system for calculating risk of operations in the stock market would be as narrow as a needle, and very, very deep in business logic. A cigarrete, more or less.

![The cone of tests as a cigarrete](/images/pyramid_of_tests_06_2014/cone-narrow-resized.jpg)

So have that pyramid in mind, but look first at how deep or wide is your system and let your incstinct do the rest.
