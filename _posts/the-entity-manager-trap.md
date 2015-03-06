---
title: The Entity Manager trap
date: 2015-02-22
---

### Falling into the hole

In 2012, a few months after I started developing with Symfony 2, I wrote a [small utility](http://www.carlescliment.com/blog/como-stubbear-facilmente-repositorios-symfony-2) - currently deprecated - that allowed you to stub chained method calls. It is, dealing with collaborators that violated the [Law of Demeter](http://c2.com/cgi/wiki?LawOfDemeter). I was having difficulties when testing some of my services that required an entity manager to perform some actions, let's say, loading some entities for one repository, creating some other ones and persisting them. In those cases, apart from using the entity manager to `persist` the entites, I had to `getRepository` and then `performSomeQuery` on it to receive a collection of objects. So I had to stub the entity manager to return a stubbed repository that returned some objects that, guess it, sometimes were mocks.

Following is an example of what I'm talking about.


```
# messages listener, v1

class MessagesListener 
{ 
    private $em; 

    public function __construct(EntityManager $em) 
    { 
        $this->em = $em; 
    } 

    public function onProductSold(ProductEvent $event) 
    { 
        $department = $event->getProduct()->getDepartment(); 
        $sales_managers = $this->em->getRepository('SalesManager')
            ->findAllByDepartment($department); 
        foreach ($sales_managers as $sales_manager) { 
            $message = new Message($sales_manager, 
               sprintf('%s has been sold', $event->getProduct->getName())); 
            $this->em->persist($message); 
        } 
    } 
} 

class MessagesListenerTest extends PHPUnit_Framework_TestCase 
{ 
    private $em; 
    private $listener; 

    public function setUp() 
    { 
        $this->em = $this->getMock('EntityManager'); 
        $this->listener = new Listener($this->em); 
    } 

    public function testItNotifiesTheSalesManagersWhenAProductHasBeenSoldInTheirDepartment() 
    { 
        $product = new Product('Lego Star Wars', Departments::TOYS); 
        $product_event = new ProductEvent($product); 
        $manager = new Manager('Aurora Basil Ocascas', Departments::TOYS); 
        $repository = $this->getMock('SalesManagerRepository', ['findAllByDepartment']); 
        $this->em->expects($this->any()) 
            ->method('getRepository') 
            ->will($this->returnValue($repository)); 
        $repository->expects($this->any()) 
            ->method('findAllByDepartment') 
            ->will($this->returnValue([$manager])); 

        $this->em->expects($this->once()) 
            ->method('persist') 
            ->with($this->isInstanceOf('Message')); 

        $this->listener->onProductSold($product_event); 
    } 
} 
```

If you have high quality standards, I can imagine your face looking at that ugly test. Stubs returning stubs returning arrays of objects is nothing other than a mess. We'll use the tool to stub method chains to make the test a bit shorter, although I doubt it makes it easier to understand. 

```
# using the stub chainer

class MessagesListenerTest extends PHPUnit_Framework_TestCase 
{ 
    // ...

    public function testItNotifiesTheSalesManagersWhenAProductHasBeenSoldInTheirDepartment() 
    { 
        $product = new Product('Lego Star Wars', Departments::TOYS); 
        $product_event = new ProductEvent($product); 
        $manager = new Manager('Aurora Basil Ocascas', Departments::TOYS); 
        $this->chainer->chain($this->em, ['getRepository', 'findAllByDepartment'], [$manager]); 

        $this->em->expects($this->once()) 
            ->method('persist') 
            ->with($this->isInstanceOf('Message')); 

        $this->listener->onProductSold($product_event); 
    } 
} 
```


The tool allowed us to save one of the stubs, making the test more compact, but it still has some problems. It tests the type of the created instance, but assumes it has been constructed properly. If you look at the implementation, it is pretty much the same as the test. That makes me think that we are testing the feature at a too low level, but I'll leave that topic to another post. Anyway, that's how I tested at that time and although not perfect, it let me continue with my TDD flow. 

Let's fix that overcomplicated test. It's claiming for a refactoring. I'll start with making Demeter happy with it. Don't worry if you don't completely like this first refactor, it's just a step to a better design.

### Climbing Demeter's rope

According de to the Demeter Law, a class should only talk to itself, to its direct collaborators, and to the objects it instantiates. This is violated by our call to the repository, so I'm going to make it a direct collaborator by passing it in construction.

```
# messages listener, v2

class MessagesListener 
{ 
    private $em; 
    private $salesManagerRepository; 

    public function __construct(EntityManager $em, SalesManagerRepository $sales_manager_repository) 
    { 
        $this->em = $em; 
        $this->salesManagerRepository = $sales_manager_repository;
    } 

    public function onProductSold(ProductEvent $event) 
    { 
        $department = $event->getProduct()->getDepartment(); 
        $sales_managers = $this->salesManagerRepository->findAllByDepartment($department); 
        foreach ($sales_managers as $sales_manager) { 
            $message = new Message($sales_manager, 
                    sprintf('%s has been sold', $event->getProduct->getName())); 
            $this->em->persist($message); 
        } 
    } 
} 


class MessagesListenerTest extends PHPUnit_Framework_TestCase 
{ 
    private $em; 
    private $salesManagerRepository;
    private $listener; 

    public function setUp() 
    { 
        $this->em = $this->getMock('EntityManager'); 
        $this->salesManagerRepository = $this->getMock('SalesManagerRepository', ['findAllByDepartment']);
        $this->listener = new Listener($this->em, $this->salesManagerRepository); 
    } 

    public function testItNotifiesTheSalesManagersWhenAProductHasBeenSoldInTheirDepartment() 
    { 
        $product = new Product('Lego Star Wars', Departments::TOYS); 
        $product_event = new ProductEvent($product); 
        $manager = new Manager('Aurora Basil Ocascas', Departments::TOYS); 
        $this->repository->expects($this->any()) 
            ->method('findAllByDepartment') 
            ->will($this->returnValue([$manager])); 

        $this->em->expects($this->once()) 
            ->method('persist') 
            ->with($this->isInstanceOf('Message')); 

        $this->listener->onProductSold($product_event); 
    } 
} 
```

With this refactor, the test look easier to read, right? We don't need stubs to return stubs or obscure utilities to do magic stuff anymore. But there is something weird with the implementation you may have noticed. We are making the clients inject a repository and an entity manager. That makes little sense because, as we saw in the first version, the repository can be brought from the entity manager.

```php
$listener = new MessagesListener($em, $em->getRepository('SalesManager'));
```

That's simply odd. If we look at the code, the only reason for injecting the entity manager is because it implements the `persist()` method to save our messages. So we have a deeper problem here, we are using two different abstractions to interact with the database. It gets weirder when the abstractions act in different levels, and one of the abstractions has direct access to the other one. But we must not forget that, in Doctrine, this relation between the manager and the repository is bidirectional. A repo has direct access to the entity manager. So let's reverse it and make repositories able to persist.

```
# Make repositories able to persist

class MessageRepository extends Repository
{
    public function persist(Message $message)
    {
        return $this->getEntityManager()->persist($message);
    }
}

$listener = new MessagesListener($em->getRepository('Message'), $em->getRepository('SalesManager'));
```


That's much better, isn't it?. There's more consistency now, since we are using the same abstractions (repositories) to access to the database. Collaborators are not related anymore, and they have a narrower scope. Furthermore, since the entity manager is hidden under the repository, we have made the listener agnostic to the system architecture (Doctrine).

Let's see it in action:

```
# messages listener, v3

class MessagesListener 
{ 
    private $messagesRepository; 
    private $salesManagerRepository; 

    public function __construct(MessagesRepository $messages_repository, SalesManagerRepository $sales_manager_repository) 
    { 
        $this->messagesRepository = $messages_repository; 
        $this->salesManagerRepository = $sales_manager_repository;
    } 

    public function onProductSold(ProductEvent $event) 
    { 
        $department = $event->getProduct()->getDepartment(); 
        $sales_managers = $this->salesManagerRepository
            ->findAllByDepartment($department); 
        foreach ($sales_managers as $sales_manager) { 
            $message = new Message($sales_manager, 
                    sprintf('%s has been sold', $event->getProduct->getName())); 
            $this->messagesRepository->persist($message); 
        } 
    } 
} 

class MessagesListenerTest extends PHPUnit_Framework_TestCase 
{ 

    private $messagesRepository; 
    private $salesManagerRepository;
    private $listener; 

    public function setUp() 
    { 
        $this->messagesRepository = $this->getMock('MessagesRepository'); 
        $this->salesManagerRepository = $this->getMock('SalesManagerRepository', ['findAllByDepartment']);
        $this->listener = new Listener($this->messagesRepository, $this->salesManagerRepository); 
    } 

    public function testItNotifiesTheSalesManagersWhenAProductHasBeenSoldInTheirDepartment() 
    { 
        $product = new Product('Lego Star Wars', Departments::TOYS); 
        $product_event = new ProductEvent($product); 
        $manager = new Manager('Aurora Basil Ocascas', Departments::TOYS); 
        $this->salesManagerRepository->expects($this->any()) 
            ->method('findAllByDepartment') 
            ->will($this->returnValue([$manager])); 

        $this->messagesRepository->expects($this->once()) 
            ->method('persist') 
            ->with($this->isInstanceOf('Message')); 

        $this->listener->onProductSold($product_event); 
    } 
} 
```

### A bit about testing strategies

The test is very much the same, but we have now a consistent design. There's still one issue, the test reflects almost line by line how the listener is implementen. We'll try to solve that by using custom doubles instead of mocks.

```
# Replacing mocks with custom doubles

class SalesManagerRepositoryDouble implements SalesManagerRepository
{ 
    public $managersByDepartment; 

    public function findAllByDepartment($department) 
    { 
        return isset($this->managersByDepartment[$departmemt]) ? 
            $this->managersByDepartment[$departmemt] : []
    } 
} 

class MessagesRepositoryDouble implements MessagesRepository
{ 
    public $persisted = []; 

    public function persist($message) 
    { 
        $this->persisted[] = $message; 
    } 
} 

class MessagesListenerTest extends PHPUnit_Framework_TestCase 
{ 
    private $messagesRepository; 
    private $salesManagerRepository;
    private $listener; 

    public function setUp() 
    { 
        $this->messagesRepository = new MessagesRepositoryDouble(); 
        $this->salesManagerRepository = new SalesManagerRepositoryDouble();
        $this->listener = new Listener($this->messagesRepository, $this->salesManagerRepository); 
    } 

    public function testItNotifiesTheSalesManagersWhenAProductHasBeenSoldInTheirDepartment() 
    { 
        $product = new Product('Lego Star Wars', Departments::TOYS); 
        $product_event = new ProductEvent($product); 
        $manager = new Manager('Aurora Basil Ocascas', Departments::TOYS);
        $this->salesManagerRepository->managersByDepartment = [ Department::TOYS => $manager ]; 

        $this->listener->onProductSold($product_event); 

        $this->assertCount(1, $this->messagesRepository->persisted); 
        $this->assertEquals($manager, $this->messagesRepository->persisted[0]->getRecipient());
        $this->assertEquals('Lego Star Wars has been sold', $this->messagesRepository->persisted[0]->getMessage());
    } 
}
```

By replacing the mocks with our test doubles, we have made the test agnostic to the implementation details. It is now focused on the outcome. A side effect is that we are not constrained by the testing framework anymore, making it easy to add picky assertions like testing the message body. The tradeoff is that we now have to maintain our doubles to respond to the same messages the actual repositories do, but we can be confident on that since the doubles implement the same interface.

The mock to double substitution is a very opinionated change. Some people will argue that mocks make it easier to test the behaviour, I don't agree with that. After years of testing, I've find that the behaviour of the system is best tested by checking the outcomes from a given input, not by testing the contract between every class. Anyway, just choose the option that fits better for you and keep focusing on the code smells to guide your refactors. 


### Conclusions

After dealing with problems like the one described here, I arrived to some conclusions.

- Demeter's Law normally exposes design problems. Don't overlook it.
- Always inject the higher-level abstractions that let you resolve the problem. In our case, the repository is far more abstract than the entity manager, which is more bounded to implementation details.
- When you feel a pain in a test, don't take shortcuts to get rid of it. This will hide the problem. Try to find out what's the root of that pain. Solve it.
