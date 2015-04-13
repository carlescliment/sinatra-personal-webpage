---
title: Life is too complicated
date: 2015-04-13
---

When I went to the university, the common mantra about Object Oriented Programming was that objects were representations of the real life. That made sense for me. We had some subjects dedicated to *modeling*. Given that software design was about mimicking the real life, the analysis phase was the most important one. We were told to expend as much time as possible working on UML diagrams of all kinds. It was the waterfall times. The act of coding was considered a necessary but an annoying step in the way to become a Senior Analyist. Programming was mere brute force, almost automatable. There were not a few attempts to create automatic code generators that would, theoretically, remove the need for human programmers. That times are over.

Anyway, it's not hard to face with other developers who seem to have that idea of *modeling real life* sealed in their skin. Even if they come from a deep, solid XP culture. They write classes and hierarchies the same way they see them in the real life. Even when using TDD, there is a subtle, unperceived up-front design. The design is not driven by the refactors, the refactors are made to match a representation of the real life.

Representing *the reality* is quite an ambitious purpose. Expecting developers to be real life sculptors is expecting too much. The fact is that *the reality* is not an unique neither immutable. It changes over time depending on the business needs and it is influenced by our perception, knowledge, context and even mood. So when a developer thinks about the reality, she is thinking about the representation she has built up in her mind. There is a double translation process there, so it works like the chinese whispers. First we make an image of the reality in our brains. The second translation involves the conversion of that image as code. So we may think we are representing an exact representation of the real life, but it is very likely we are not.

![Ecce Homo](/images/2015/life-is-too-complicated/ecce-homo.png)

What do developers do, if not to model the reality? I think there is something that we should try to excel in: managing complexity. We can think of an application as a black box. You put some values in and it returns the result. That result can be a new file in the filesystem, a database record update, a request to an external service, etcetera. But there is always an input and output. The relationship between the input and the output is what we call *behaviour*. The application behaves in a certain way if, given some preconditions, it is expected to produce an output.

Every time we add a new feature to the system, the complexity inside of that black box is increased. Our task as developers is to reduce the impact of that complexity increase as much as possible. Normally we do that by applying refactoring techniques and design and architecture patterns. Instead of being sculptors, we are more like tightrope walkers. While walking the new features, we try to keep the long bar of complexity balanced. If the complexity is attracted in a single class, the whole system can destabilise and fall off.

In the real life, things may be very complex. When a child smiles, he activates 17 to 26 different muscles. The HIV contains 9,749 pairs in its genome. Mimicking the reality is nothing else but playing to be gods.


![Tightrope walker](/images/2015/life-is-too-complicated/walker.jpg)

A couple of interesting links:

- [Real World Modeling](http://intra.info.uqam.ca/Members/mili_h/Enseignement/inf5151-aut06/documents/OO-real-world-modeling.pdf)
- [OOP practiced backwards is "POO"](http://raganwald.com/2010/12/01/oop-practiced-backwards-is-poo.html)

