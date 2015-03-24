---
title: The Abc metric versus Martin Fowler
date: 2015-03-24
---

Do you imagine if there was an algorithm that let us evaluate the quality of a book and turn it into a discrete number? It could count the number of different characters, the deepness in their description, or how many times certain words are repeated in the book. Or the average paragraph length, or the % of the words of the dictionary used. Given that, *Crime and punishment* could be a 176 while *Les Misérables* could score a still respectable 152. *"That's crazy"*, you'll say, but if we could standarize what objective traits make literature good, it shouldn't be that hard to extract a metric.

Fortunately, nobody tries to put literature in objective terms. But we do it with software. Is it right? Is it fair to compare literature and programming? I'm not in position to give responses for that, but please lets keep talking about metrics.

### The Abc metric

The first time I heard about this metric was in a conference about QA and testing, during a conversation with a consultant working for a well known quality experts company in Valencia. She told me that she pushed the Abc metric in some projects she was assisting, and the results where surprising since they often laughed at - apparently - good code. She was having problems with some programmers that were very resilient to make changes in their code to satisfy the metric thresholds. I found the story quite interesting and this very same day, after having dinner, I asked Google about it.

The [Abc metric](http://c2.com/cgi/wiki?AbcMetric) is a measure of software size. It stands for *Assignment*, *Branch*, *Condition*. The final sum of each one of these three aspects tells us how big the code we are analyzing is. Assignments refers to using variables to store data, branches are jumps in the execution flow (methods, functions and operators) and conditions are the different paths the execution flow can take. The biggest the number, the biggest the code.

In this post we are going to test the metric against a few refactorings suggested by [Martin Fowler](http://martinfowler.com/) in his book [Refactoring: Improving the design of existing code](http://www.amazon.com/Refactoring-Improving-Design-Existing-Code/dp/0201485672)

### The experiment

We will start with two simple refactors: [Extract Method](http://refactoring.com/catalog/extractMethod.html) and [Introduce Explaining Variable](http://refactoring.com/catalog/extractVariable.html). We will finish the experiment with a final more complex, third refactor: [Replace conditional with polymorphism](http://refactoring.com/catalog/replaceConditionalWithPolymorphism.html). We will use the Abc metric before and after the refactors are made to compare the results and see if we can get to any conclusion.


#### Case I: Extract Method

* Original overall size: 3
* Refactored overall size: 5

```ruby
# Before

class Printer
  def print_owning(amount)
    print_banner

    puts 'The name'
    puts 'The amount '+amount.to_s
  end

  def print_banner
    # prints the banner
  end
end
```

```ruby
# After

class Printer
  def print_owning(amount)
    print_banner
    print_details(amount)
  end

  def print_banner
    #prints the banner
  end

  def print_details(amount)
    puts 'The name'
    puts 'The amount '+amount.to_s
  end
end
```

#### Case II: Introduce Explaining Variable

* Original overall size: 10
* Refactored overall size: 11

```ruby
# Before

class ExplainingVariable
  def do(platform, browser)
    if (!platform.capitalize.index('MAC').nil?) &&
        (!browser.capitalize.index('IE').nil?) &&
        was_initialized &&
        resize > 0
      do_something
    end
  end

  def was_initialized
  end

  def resize
  end

  def do_something
  end
end
```

```ruby
# After

class ExplainingVariable
  def do(platform, browser)
    is_mac_os = !platform.capitalize.index('MAC').nil?
    is_ie_browser = !browser.capitalize.index('IE').nil?
    was_resized = resize > 0
    if is_mac_os &&
        is_ie_browser &&
        was_initialized &&
        was_resized
      do_something
    end
  end

  def was_initialized
  end

  def resize
  end

  def do_something
  end
end
```

#### Case III: Replace conditional with polymorphism

* Original overall size: 31
* Refactored overall size: 45

The code here is a bit longer, please compare [the original version](https://github.com/carlescliment/sinatra-personal-webpage/blob/7b69dc6ea330cd1fbb0cfb9b33a0ac815d85fb10/_samples/abc/conditional_polymorphism/replace_conditional_with_polymorphism.rb) with [the refactored one](https://github.com/carlescliment/sinatra-personal-webpage/blob/0b3c3671a1276593bd595046cd8b0c88a5acac12/_samples/abc/conditional_polymorphism/replace_conditional_with_polymorphism.rb).


### Conclusions

All the changes made by Mr. Fowler increased the size of the codebase. Any variable added to improve the semantics and any method extracted was punished by the Abc metric because of that. Is Mr. Fowler wrong? Is there a real correlation between software size and software quality? If not, why was a QA expert imposing that metric to the team?

Introducing a wrong metric to development teams and constraining them to respect metric thresholds had a cost, undoubtedly. Most of these teams were part of big companies looking for a quality seal. Do you know why? Because they worked for the public administration and that seal would give them some advantage. Do you guess who paid the bill in the end? How many copies of *Refactoring: Improving the design of existing code* could have been bought and given to the team with that money?
