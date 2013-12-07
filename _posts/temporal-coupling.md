---
title: Temporal coupling
date: 2013-12-07
---

## Introduction

During the last days I've been really busy writing some materials for a course I'll be giving about Symfony 2. I try not to remain on the basics, but also explain as deeply as I can the reasons behind each design decision in the framework. I tend to do a little research before writing things down and take the best explanations I find as a reference. But today, looking for good materials about temporal coupling, I got lost.

In case that anybody else makes the same research in the future, I would like to bring some water to the field.


## What is temporal coupling?

According to [the article in wikipedia](http://en.wikipedia.org/wiki/Coupling_(computer_programming)):

```
When two actions are bundled together into one module just because they happen to occur at the same time.
```

In code, imagine we have a website that manages cooking recipes. It provides a form that allows cookers to publish their own recipes. Each time a form is submitted, three things happen:

- The recipe is stored in the database.
- An email is sent to the website administrator.
- A line is written into a log file.

So this is what we have:

```python
# recipes.py

""""
The controller
""""
class RecipeController:

    def create(self, request):
        recipe = self.extract_recipe_from_request(request)
        creator = app.service('recipe_creator')
        creator.create(recipe)
        redirect("/recipes/%d"%(recipe.id))


    def extract_recipe_from_request(self, request):
        # ...
        return recipe

""""
The creator
""""
class RecipeCreator:

    def __init__(self, database, mailer, logger):
        self.database = database
        self.mailer     = mailer
        self.logger     = logger


    def create(self, recipe):
        self.save(recipe)
        self.send_mail_to_admins(recipe)
        self.log_new_recipe(recipe)


    def save(self, recipe):
        # ...


    def send_mail_to_admins(self, recipe):
        # ...


    def log_new_recipe(self, recipe):
        # ...

```

The `RecipeCreator` is the only class of the system that knows how to create recipes. One day, while we are having a shower, we have a great idea: we could provide our application as a framework, so that everybody could create and host its own cooking recipes website. We package our application as a lib, publish it in Github and feel that we have done a great service to the humankind.


One day, a fellow developer writes to us. He is using our component but he doesn't want to receive emails anymore. His application is more successfull than ours, and he begins to feel very overwhelmed. The problem is he doesn't know how to change the behaviour when creating a new recipe.

Everything is temporally coupled. How can we solve the temporal coupling, then?



## Dealing with it... the wrong way

### Procedural style
We struggle our minds thinking on how can our mate solve her problem. The first idea is, what if we add flags to the create method?

```python
# recipes.py

class RecipeCreator:

    #...

    def create(self, recipe, send_mail = true, log = true):
        self.save(recipe)
        if (send_mail):
            self.send_mail_to_admins(recipe)
        if (log):
            self.log_new_recipe(recipe)
```

Now, she just has to change his controller, calling the component with the appropriate flags:

```
    creator.create(recipe, false, true)
```

After thinking a bit more, we arrive to the conclusion that this is not a good idea. Conditionals makes classes more complex and unpredictable, because **there are different possible execution flows**. It also doesn't seem a very object oriented approach.

### Inheritance
Instead, we write a new class `LoggerOnlyRecipeCreator` which inherits the original creator. The child overrides the parent default behaviour, skipping the email stuff. Other apps could configure their services depending on the class they want to use.

```python
# recipes.py

class LoggerOnlyRecipeCreator(RecipeCreator):

    #...

    def create(self, recipe):
        self.save(recipe)
        self.log_new_recipe(recipe)
```

We hurry to write other possible combinations. We don't want more complaints!

```python
# recipes.py

class MailOnlyRecipeCreator(RecipeCreator):

    #...

    def create(self, recipe):
        self.save(recipe)
        self.send_mail_to_admins(recipe)

class SilentRecipeCreator(RecipeCreator):

    #...

    def create(self, recipe):
        self.save(recipe)
        self.send_mail_to_admins(recipe)
```

After looking at all that classes overriding methods, we realize hoy messy it is. We would need **a subclass for every single combination**!


### Null objects

We have heard many times that composition is better than inheritance. The creator uses composition, receiving a mailer and a logger in the constructor, so maybe we can make the most of it. We write **null objects**.

```python
# recipes.py

class NullMailer:

    def send(self, email):
        pass


class NullLogger:

    def log(self, level, message):
        pass
```

Hey, that seems clever! Now anyone could inject a `NullMailer` or a `NullLogger` if he doesn't want things to happen. But there is something weird about passing objects that do nothing, right? Should we **write Null versions for each component** in our application? Seems not a good design to us, so we keep on thinking.




## Patterns

### Observer

In the observer pattern, a recipe would own a set of observers. When needed, the recipe would notify them.

```python
# recipes.py

class Recipe:

    def __init__(self, observers = []):
        self.observers = observers

    def save(self, database):
        database.save('recipes', self.to_array)
        for observer in self.observers:
            observer.notify('save', self)



class EmailRecipeObserver:

    def notify(self, recipe):
        #...

class LogRecipeObserver:

    def notify(self, recipe):
        #...

```

Then each observer could do its task. Changing the behaviour is as easy as passing the corresponding observers when creating the recipe. No creator class is needed in the middle.

The problem with the observer pattern is that it couples instances being observed with their observers. Or more far going, **a class should not even know that it is being observed**. A lot has been written about the inconveniences of the Observer pattern. This post in StackOverflow is a good start:

[Why should the observer pattern be deprecated](http://stackoverflow.com/questions/11619680/why-should-the-observer-pattern-be-deprecated)



### Mediator

The Mediator pattern resolves some of the problems seen in the Observer pattern. Basically, it adds a class between the observers and the objects being observed, decoupling them. Because an instance should not even know that it is being observed, we don't inject the mediator in the recipe constructor. All the stuff is controlled by the controller. Seems logical, right?

```python
# recipes.py

class RecipeController:

    def create(self, request):
        recipe = self.extract_recipe_from_request(request)
        database = app.service('recipe_creator')
        recipe.save(database)
        app.call_mediator('recipe_save', recipe)


class Mediator:
    def __init__(self, observers = []):
        self.observers = observers

    def call(event_name, instance):
        for observer in self.observers:
            observer.call('event_name', instance)
```

This is a very simple implementation of the Mediator pattern, in which all the observers are called for each event. Of course more efficient versions could be written.


After implementing the mediator, we promise not to fall into temporal coupling again when publishing services.





















