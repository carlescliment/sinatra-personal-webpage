---
title: Life is too complicated
date: 2015-04-13
---

When I was studying at university, the common mantra about Object Oriented Programming was that objects were representations of real life. We had some subjects dedicated to *software modeling* in which we were trained in UML diagrams of all kinds. Given that software design was about mimicking real life, the analysis phase was considered the most important. It was during the time of the classic *Waterfall* method, and the act of coding was considered a necessary evil – an annoying step – on our way to becoming a Senior Analyst. Programming was mere brute force, almost automatable. There were several attempts to create automatic code generators that would, theoretically, remove the need for human programmers. Luckily, those times are gone.

It's not uncommon however, to still meet developers with this predilection for *modeling real life*, even among those coming from a deep and solid XP culture.  When practicing TDD they sometimes show a subtle, almost imperceptible, tendency towards up-front design. In these situations, code smells don't drive refactors; instead, refactors are done to align the code with real life.

Representing reality is quite an ambitious project. Expecting developers to be expert business analysts is way too much. Reality is neither unique nor immutable, it changes over time depending on business needs and is influenced by our perception, knowledge, context and even mood. So when a developer thinks about reality, they are thinking about the representation they have built up in their mind. There is a triple translation process going on here, which has an effect not unlike the game Chinese whispers. First, developers have conversations with business analysts, product owners or users in order to collect information about reality. Second, we process that information, as we understand it, to create an image or model of said reality in our brains. Finally, we translate that image into code. In the end, what we trust as representing reality in our code is unlikely to match up with the real world, or at the very least, not resemble it as much as we would like.

![Ecce Homo](/images/2015/life-is-too-complicated/ecce-homo.png)

What are developers to do then, if not to model reality? I think there is something that we should try to excel in: managing complexity. We can think of an application as a black box. You put some values in and it returns a result. That result can be a new file in the filesystem, a database record update, a request to an external service, etc. But there is always an input and output. The relationship between the input and the output is what we call *behaviour*. The application behaves in a certain way if, given some preconditions, it produces an expected output.

Every time we add a new feature to the system, the complexity inside of that black box is increased. Our task as developers is to reduce the impact of that complexity increase as much as possible. Normally we do that by applying refactoring techniques, and design and architecture patterns. Instead of being sculptors, we are more like tightrope walkers. While walking through the new features, we try to keep the long bar of complexity balanced. If the complexity is all condensed into a single class, the whole system can destabilise and fall.

![Tightrope walker](/images/2015/life-is-too-complicated/walker.jpg)

In real life, things may be very complex. When a child smiles, they activate  17 to 26 different muscles. The HIV virus contains 9,749 pairs in its genome. Mimicking reality is nothing else but playing at being gods.

A couple of interesting links:

- [Real World Modeling](http://intra.info.uqam.ca/Members/mili_h/Enseignement/inf5151-aut06/documents/OO-real-world-modeling.pdf)
- [OOP practiced backwards is "POO"](http://raganwald.com/2010/12/01/oop-practiced-backwards-is-poo.html)

