---
title: The test pyramid
date: 2014-06-03
---


### The test pyramid

It has been said many times that your test suite should look like a pyramid, with end-to-end tests at the top and the unit tests at the bottom. In other words, you should write far more unit tests than acceptance or functional ones. There are lots of advantages to this, e.g. your tests will be faster, stronger and easier to change. For a deeper description of the concept, please visit this [post by Martin Fowler](http://martinfowler.com/bliki/TestPyramid.html). I don't disagree with what he says, but there is something I dislike – it has been taken as an unbreakable law.


During the last few years I've been very concerned about my own tests and where they're going, particularly noticing how they tend towards being slower. Was I doing it wrong? Maybe I was some of the time, but thinking more deeply about the matter I've come to think that we are oversimplifying. Maybe I shouldn't be taking the pyramid model as being inflexible. So I developed my own model which is not a pyramid any more.


### The test cone

The ratio of unit and functional tests depends, of course, on the application you are writing. There are at least two factors involved: the width of the system (how many entry points it has or how many features) and the complexity of the business model. The diameter of the cone base depends on the first factor. The height of it, on the second.

![The cone of tests](/images/pyramid_of_tests_06_2014/cone-resized.jpg)

Given that, a heavy-CRUD application with lots of administration tasks would look something like a chinese hat.

![The cone of tests as a chinese hat](/images/pyramid_of_tests_06_2014/cone-wide-resized.jpg)

In contrast, a system for calculating risks for stock market transactions would be as narrow as a needle, and very, very deep in business logic. A cigarette or maybe a knitting needle, for example.

![The cone of tests as a cigarrete](/images/pyramid_of_tests_06_2014/cone-narrow-resized.jpg)

It's OK to keep the pyramid in mind, but first look at how deep or wide your system is and then let your instinct do the rest.
