---
title: Modularity
date: 2015-07-30
---


### Introduction

> Look back to where you have been, for a clue to where you are going.


I was a Python developer during the first four years of my professional career, but it was before _my awakening_ as a programmer. Most of us wake up as devs at some time in our life, for some others it never happens. The awakening is that period of time in which you realize you aren't enjoying your profession enough, so you start reading and experimenting to go beyond. And the more you discover, the more you feel the joy of being a programmer.

In this post, my intention is to describe how the platforms I've mostly worked with during my career try to keep boundaries decoupled. I'll start with Drupal to continue with Symfony II, and finally I'll share my thoughts about Rails, the agile community and the phobia to software architecture.

### Drupal 6-7

Drupal is a CMS written in PHP, good for site builders and horrible for software developers. I've complained for long about this huge pile of... code due to its untestability and its dependency on the database, among other things. But apart from those well known problems, there are a couple of good things in Drupal.

If you want to apply some customizations to your Drupal application, you have to write a module. Modules in Drupal work the same way as plugins in Wordpress. You might add modules to enable WYSIWYG in some of your forms or to send tweets via the Twitter API. Drupal opens a predefined set of entry points called *hooks* to allow the modules change its behaviour. For instance, there is a *hook_menu* to add new URIs to the router. The implementation is as naive as effective. At some point during the bootstrap of the CMS, it iterates over all the enabled modules and looks if there is a defined `name_of_the_module_name_of_the_hook()` function. So if a module `foo` implements `foo_menu()`, it will extend the router with any additional URI it wants to provide. 

The modules also help keep the domain logic in isolated boundaries. For instance, in the e-learning platform I helped to build, we had several content types: videos, articles or news, among others. We also had a leveling system for the students to unblock content, a points system and a shop to exchange those points for products such as T-shirts, books or personal coachings. The application domain was quite rich, and we had organized it in independent - we did our best -, isolated modules/contexts. 

But the real power came after combining domain hooks with domain modules. Not only your modules could respond to Drupal hooks, you could create your own to let your modules loosely interact between them. You could enable or disable a whole part of your website with a Drush command!.


### Symfony

When I left my previous job to start a personal project, I faced a difficult decision. Should I build it with PHP? There has always been a pythonist in my heart but, on the other hand, I had played a little bit with Ruby and I liked its elegance. Anyway, during that time I used to go to Drupal conferences as a speaker and I had earned a little bit of reputation in the Spanish PHP scene, so I decided to stick to it just in case my project failed - and it did. I don't regret that decision, since it let me know Symfony, a framework full of best practices and design principles. It also let me start earning money very quickly later when I had spent almost my last cent.

Back to Symfony, your code is built on your platform by writing bundles. To be honest, I still don't have a clear vision of what a bundle is. I've seen programmers putting all the logic in a single ApplicationBundle, and others creating as many bundles as entities in the database. The fact is that there is no analogy between Drupal modules and Symfony bundles. Anyway, Symfony makes the most of the last PHP versions to introduce Object Oriented concepts and organize the source code in namespaces, which let you keep your boundaries isolated as well. The EventDispatcher component is the glue to kep your boundaries working together.

The EventDispatcher is an implementation of the [Mediator pattern](http://c2.com/cgi/wiki?MediatorPattern). It's an application service provided by the framework that lets you trigger your own events and subscribe listeners to respond to them. Coming from Drupal, understanding this principle was a piece of cake for me.

After getting to Symfony, I've worked with some other platforms in PHP such as legacy Codeigniters, old Drupals and Silex APIs. And whenever I've seen a rich domain, there I've brought the Symfony EventDispatcher component. Specially after diving myself into DDD.


### Rails

The Rails culture has pioneered many good things in software development, but modularity was not among them. A typical Rails application is organized in four layers: controllers, views, models and services. There are other artifacts such as presenters or decorators, mainly to help rendering stuff in the views.

Rails services are more or less like the old style huge controllers. God-like classes that know all the things about the execution flow. Those who defend the services approach talk about the benefits of stateless objects. I suspect that those services are stateless just because the state is spread somewhere else, in behaviourless active record monsters with absolute contempt for the basic object-oriented principle of encapsulation: putting state and behaviour as close as possible, whenever possible.

In this scenario, I soon felt completely uncomfortable. I was surprised when good developers insta-rejected all my previous experience about modularity and events. I wouldn't understand they had good reasons until much later. 

An implementation such as the Symfony EventDispatcher component cannot be directly translated to Ruby, or at least can't in a Rails environment. It feels completely unnatural in a world in which even dependency injection doesn't fit. Fortunately, the Ruby community is full of people who like to receive influences from outside, who eagerly read papers and books, who don't feel any comfort in the comfort zone. Is that people with deep roots in the Ruby language who will lead the change that will come to the Rails community, in its own flavour. It won't look like Symfony EventDispatcher. It won't look like Drupal modules. But, you know, good things go without saying.
