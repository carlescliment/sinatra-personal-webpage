---
title: Life is too complicated
date: 2015-04-13
---

When I was studying at the university, the common mantra about Object Oriented Programming was that objects were representations of the real life. We had some subjects dedicated to *software modeling* in which we were trained in UML diagrams of all kinds. Given that software design was about mimicking the real life, the analysis phase was the most important one. It was the waterfall times, and the act of coding was considered a necessary but an annoying step in our way to become a Senior Analyst. Programming was mere brute force, almost automatable. There were several attempts to create automatic code generators that would, theoretically, remove the need for human programmers. Luckily, that times are over.

Anyway, it's not uncommon to meet developers with that predilection for *modeling the real life* nowadays. Even among those coming from a deep, solid XP culture. Even when practicing the TDD practice, they sometimes show a subtle, unperceived tendency to up-front design. In those situations the code smells don't drive the refactors, the refactors are made to align the code with the real life.

Representing *the reality* is quite an ambitious purpose. Expecting developers to be expert business analysts is way too much. The *reality* is not unique neither immutable, it changes over time depending on the business needs and it is influenced by our perception, knowledge, context and even mood. So when a developer thinks about the reality, she is thinking about the representation she has built up in her mind. There is a triple translation process there, so it works like the chinese whispers. First, developers have conversations with business analyst, product owners or users in order to bring information about that reality. Second, we process that information to create an image of the reality in our brains. Finally, we translate that image into code. In the end, what we trust to be the reality is very likely to mismatch it, or at least not to be as exact as we would like to.

![Ecce Homo](/images/2015/life-is-too-complicated/ecce-homo.png)

What do developers do, if not to model the reality? I think there is something that we should try to excel in: managing complexity. We can think of an application as a black box. You put some values in and it returns the result. That result can be a new file in the filesystem, a database record update, a request to an external service, etcetera. But there is always an input and output. The relationship between the input and the output is what we call *behaviour*. The application behaves in a certain way if, given some preconditions, it is expected to produce an output.

Every time we add a new feature to the system, the complexity inside of that black box is increased. Our task as developers is to reduce the impact of that complexity increase as much as possible. Normally we do that by applying refactoring techniques and design and architecture patterns. Instead of being sculptors, we are more like tightrope walkers. While walking the new features, we try to keep the long bar of complexity balanced. If the complexity is attracted in a single class, the whole system can destabilise and fall.

![Tightrope walker](/images/2015/life-is-too-complicated/walker.jpg)

In the real life, things may be very complex. When a child smiles, he activates 17 to 26 different muscles. The HIV contains 9,749 pairs in its genome. Mimicking the reality is nothing else but playing to be gods.

A couple of interesting links:

- [Real World Modeling](http://intra.info.uqam.ca/Members/mili_h/Enseignement/inf5151-aut06/documents/OO-real-world-modeling.pdf)
- [OOP practiced backwards is "POO"](http://raganwald.com/2010/12/01/oop-practiced-backwards-is-poo.html)

