---
title: Curso Metodologías Ágiles y TDD, parte IV
date: 2014-07-10
author: Carles Climent Granell
license: All rights reserved to Carles Climent Granell. This material cannot be reproduced or used without express authorization of the author, as a whole or fragmented.
---


# Curso de Metodologías Ágiles y TDD, Parte IV

## Testing en Symfony2: Recetas

### Cómo hacer login a través de HTTP

```yaml
# app/config/config_test.yml

security:
    firewalls:
        main:
            provider: in_memory
            pattern:    ^/
            anonymous: ~
            form_login: ~
            http_basic:

    providers:
        in_memory:
            memory:
                users:
                    admin:  { password: test, roles: ['ROLE_ADMIN'] }

    encoders:
        Symfony\Component\Security\Core\User\User: plaintext
```

```php
# src/Acme/DemoBundle/DemoTest.php
namespace Acme\DemoBundle\Tests;

use Symfony\Bundle\FrameworkBundle\Test\WebTestCase;

class DemoTest extends WebTestCase
{
    /**
     * @test
     */
    public function anAdminCanAccessToAdminInterfaces()
    {
        $client = self::createClient([], [
            'PHP_AUTH_USER' => 'admin',
            'PHP_AUTH_PW' => 'test',
            ]);

        $client->request('GET', '/admin');

        $this->assertTrue($client->getResponse()->isSuccessful());
    }
}
```


### Cómo testear servicios

```php
# src/Acme/DemoBundle/DemoTest.php
namespace Acme\DemoBundle\Tests;

use Symfony\Bundle\FrameworkBundle\Test\WebTestCase;

class DemoTest extends WebTestCase
{
    /**
     * @test
     */
    public function anAdminCanAccessToAdminInterfaces()
    {
        $client = self::createClient([], [
            'PHP_AUTH_USER' => 'admin',
            'PHP_AUTH_PW' => 'test',
            ]);
        $container = $client->getKernel()->getContainer();
        $twitter = $this->getMock('Acme\DemoBundle\Model\Twitter');
        $container->set('twitter_api', $twitter);
        $tweet = 'This is the message to send to twitter';

        $twitter->expects($this->once())
            ->method('tweet')
            ->with($tweet);

        $client->request('POST', '/tweet/send', ['message' => $tweet]);
    }
}
```
