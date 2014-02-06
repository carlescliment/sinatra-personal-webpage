---
title: Orientación a objetos, Principio de Hollywood y algunos patrones
date: 2013-02-07
---

# Parte I: Conceptos Teóricos

## Introducción

A menudo pienso que nuestra travesía en el campo de la programación se parece a la de los escaladores. Ambos buscamos una cima, el conocimiento en nuestro caso, y ambos debemos conducir nuestro ascenso con paciencia y sin atajos. En cada nueva técnica que aprendemos y en cada concepto que asimilamos aseguramos nuestra subida con un nuevo punto de anclaje. A diferencia de los escaladores, los programadores no asumimos ningún riesgo en nuestro avance, más al contrario avanzamos gracias a nuestros errores. Nuestro inconveniente, sin embargo, es que nuestra cima es inalcanzable. A medida que avanzamos hacia ella se nos revela más y más lejana. Por eso, tal vez en nuestro caso, lo que importa no es lo que queda por recorrer sino lo que ya hemos avanzado.

![Mito de Sísifo](/images/orientacion_objetos_02_2014/sisifo.jpg)

> Así como Sísifo empuja eternamente su roca, los programadores aprendemos para descubrir que seguimos sabiendo apenas nada.



En mi escalada particular he encontrado grandes puntos de anclaje. En orden cronológico destacaría la lectura de *Clean Code*, el contacto con el *Test Driven Development* y el estudio de *Patrones de Diseño*, en el que ando ahora inmerso.

Siempre con la *Orientación a Objetos* como trasfondo, a pesar de ir aprendiendo de manera progresiva nunca he conseguido quitarme de encima cierta sensación de inseguridad en mi propio código. ¿Lo estoy haciendo bien?.

¿Por qué es tan difícil la programación orientada a objetos?.


## SOLID

El acrónimo SOLID no puede faltar en toda charla o coloquio sobre orientación a objetos. No puedo resistirme a hacer un pequeño repaso a este conjunto de principios que nos regalaron Uncle Bob y otros autores. Conviene estudiar estos principios detenidamente a través de sus autores.

- **Single Responsibility Principle**[1]: Toda clase debería hacer una (y solo una) cosa. Formulada de otra manera, solo debería haber un único motivo para modificar una clase.
- **Open/Closed Principle**[2]: Abierto a extensión, cerrado a modificación. Utilizar abstracciones en lugar de instancias concretas. Evitar atributos públicos y protegidos. Evitar variables globales. _Ejemplo cerrado a extensión: query builder_.
- **Liskov Substitution Principle**[3]: Si B es una subclase de A, entonces deberíamos poder cambiar todas las instancias de A por instancias de B sin afectar a los clientes que las utilizan.
- **Interface Segregation Principle**[4]: Los clientes no deberían verse obligados a depender de interfaces que no necesitan. Evita interfaces complejas segregándolas en otras más pequeñas. _Ejemplo interfaz contaminada: Once, Testable_
- **Dependency Inversion Principle**[5]: Las clases de mayor nivel no deberían depender de las clases de menor nivel. Ambas deberían depender de abstracciones. Las abstracciones no deberían depender de detalles. Los detalles deberían depender de abstracciones.


Familiarizarse con SOLID es costoso. ¡Son muchos conceptos que asimilar! Además el principal problema de SOLID es que explica cómo debería ser nuestro código, pero no nos ofrece una guía para llegar a él. Personalmente, mis intentos de hacer _buena_ programación orientada a objetos tomando como referencia SOLID han acabado bastante mal, con multitud de clases e interfaces innecesarias y otras señales de sobreingeniería. Pienso que SOLID debe llegar por sí mismo, sin forzar, a través del dominio del refactoring y el estudio de principios de diseño.

Bien, pero si SOLID no debe ser, al menos al principio, nuestra guía hacia el software orientado a objetos... ¿por dónde empezamos?.

Normalmente las personas que estamos intentando dominar la orientación a objetos venimos de la programación procedural. Si destacásemos un punto clave que separa ambos mundos, tal vez el más representativo sea la inversión de control (relacionada con la *D* de SOLID).

# Inversión de control

La inversión de control[6], también conocida como *Principio de Hollywood* en referencia al _slogan_ de los directivos de Hollywood _"No nos llames, nosotros te llamaremos"_, es un principio de diseño que busca mayor cohesión y menor acoplamiento entre los componentes de un sistema informático.

A diferencia de la tradición procedural, los componentes de mayor nivel son responsables de proporcionar abstracciones a los de menor nivel. Las instancias concretas de estas abstracciones son reemplazables y necesitan una interfaz común. El flujo por lo tanto se invierte, ahora son las capas superiores las que controlan a las inferiores, y no al revés.

```php
<?php
public function save(array $account_data) {
    $account = Account::createFromArray($account_data);
    // we call a higher-level class
    $em = \Application::GetDoctrine()->getEntityManager();
    $em->persist($account);
    // ...
}


// A higher level class provides an abstraction
public function save(array $account_data, ObjectManager $om) {
    $account = Account::createFromArray($account_data);
    $om->persist($account);
    // ...
}
?>
```

La técnica más común para conseguir la inversión de control es la **inyección de dependencias**. En los lenguajes de programación dinámicos existen algunas alternativas, como la metaprogramación, que no veremos en este material. La clave consiste en asegurar un flujo unidireccional de ejecución, desde clases de mayor nivel de abstracción hacia clases de mayor detalle. Los sistemas informáticos se convierten así en un conjunto coherente de piezas sustituíbles. Estas piezas no se transforman cada vez que surge un nuevo requisito, sino que se reemplazan.


## Tell, don't ask

En la Biblioteca Pragmática, Andy Hunt y Dave Thomas escribieron un artículo llamado _Tell, don't ask_[7] en el que describían este principio. El artículo empezaba con una cita del libro _Smalltalk By Example_, disponible gratuítamente en la Red[8].

> Procedural code gets information then makes decisions. Object-oriented code tells objects to do things.


En su artículo, Hunt y Thomas advierten de los riesgos de romper el encapsulamiento a través de la extracción de los datos de otras clases. Esto es,

> The fundamental principle of Object Oriented programming is the unification of methods and data.

Exponiendo el estado de una clase a las demás para que aquellas puedan manipularla no sólo estamos violando su encapsulamiento y asumiendo riesgos, sino que estamos moviendo responsabilidades hacia las clases de mayor nivel.

Siguiendo los razonamientos de los autores, cuando una clase requiera conocer el estado de otra clase, conviene preguntarse qué uso va a darse a esos datos, y mover siempre que sea posible esa manipulación a la clase expuesta, evitando la dispersión y propagación de estado.

Martin Fowler escribe también sobre este principio[9], y aunque coincide en la importancia de la co-locación de estado y comportamiento, recuerda que también deben tomarse en consideración otros aspectos como la separación en capas. En su artículo GetterEradicator[10], Fowler escribe:

> Allocation of behavior between objects is the essence of object-oriented design, so like any design, there isn't a hard and fast rule - rather a judging of trade-offs.


## Ley de Démeter

La Ley de Démeter[11][12] es un principio de diseño de software que tiene como objeto desacoplar las conexiones entre objetos, en busca de sistemas _"Adaptativos"_. Formalmente dice:

> Ley de Démeter:
>
> Un método "M" de un objeto "O" solo debería invocar a;
>
> - Sí mismo.
> - Sus parámetros.
> - Cualquier objeto que instancie.
> - Sus componentes directos

La idea subyacente es evitar la invocación de métodos en cadena, que implican el conocimiento de los componentes internos de otras clases.

```php
<?php
$this->getDoctrine()->getEntityManager()->flush();
?>
```

Si bien en los textos referenciados se sugiere la solución de añadir métodos en forma de envoltorio de las subclases, `$this->flushEntityManager()`, la Ley debe tomarse como un indicador de la existencia de problemas en el diseño, y de excesivo acoplamiento entre objetos.

## Composición versus herencia
Pdte.



## Patrones de Diseño

Los patrones de diseño son soluciones concretas a problemas habituales en el desarrollo del software. Se denominan **patrones** porque son utilizados, con sus variantes, por una amplia porción de la comunidad de programadores. El término se acuñó a finales de los setenta[13], pero no fue hasta bastante después que se extendió su uso gracias a la publicación del libro _"Design Patterns: Elements of Reusable Object-Oriented Software"_[14] y otros posteriores.

La mayoría de programadores hemos utilizado estos patrones de diseño, aún inconscientemente. La ventaja de darles nombre, catalogarlos y estudiarlos en detalle es que permiten identificar las situaciones donde aplicar estos patrones resulta más beneficioso.

Aunque generalmente el uso de patrones de diseño favorece la salud del software, conviene ser cautos y evitar el abuso. Algunos autores ya han escrito sobre las ventajas y riesgos de cada patrón[15][16].

Introducidos los conceptos teóricos necesarios, es hora de mostrar algunos ejemplos.



## Referencias
- [1] SRP, *Robert C. Martin*. [https://docs.google.com/open?id=0ByOwmqah_nuGNHEtcU5OekdDMkk](https://docs.google.com/open?id=0ByOwmqah_nuGNHEtcU5OekdDMkk)
- [2] OCP, *Robert C. Martin*. [http://www.objectmentor.com/resources/articles/ocp.pdf](http://www.objectmentor.com/resources/articles/ocp.pdf)
- [3] LSP, *Robert C. Martin*. [https://docs.google.com/open?id=0ByOwmqah_nuGNHEtcU5OekdDMkk](https://docs.google.com/open?id=0ByOwmqah_nuGNHEtcU5OekdDMkk)
- [4] ISP, *Robert C. Martin*. [http://www.objectmentor.com/resources/articles/isp.pdf](http://www.objectmentor.com/resources/articles/isp.pdf)
- [5] DIP, *Robert C. Martin*. [http://www.objectmentor.com/resources/articles/dip.pdf](http://www.objectmentor.com/resources/articles/dip.pdf)
- [6] InversionOfControl, *Martin Fowler*. [http://martinfowler.com/bliki/InversionOfControl.html](http://martinfowler.com/bliki/InversionOfControl.html)
- [7] Tell, Don't Ask, *Andy Hunt, Dave Thomas*. [http://pragprog.com/articles/tell-dont-ask](http://pragprog.com/articles/tell-dont-ask)
- [8] Smalltalk by Example, *Alec Sharp*. [http://stephane.ducasse.free.fr/FreeBooks/ByExample/SmalltalkByExampleNewRelease.pdf](http://stephane.ducasse.free.fr/FreeBooks/ByExample/SmalltalkByExampleNewRelease.pdf)
- [9] TellDontAsk, *Martin Fowler* [http://martinfowler.com/bliki/TellDontAsk.html](http://martinfowler.com/bliki/TellDontAsk.html)
- [10] GetterEradicator, *Martin Fowler* [http://martinfowler.com/bliki/GetterEradicator.html](http://martinfowler.com/bliki/GetterEradicator.html)
- [11] Demeter: Aspect-Oriented Software Development, *Karl J. Lieberherr* [http://www.ccs.neu.edu/research/demeter/](http://www.ccs.neu.edu/research/demeter/)
- [12] Introducing Demeter and its Laws, *Brad Appleton* [http://www.bradapp.com/docs/demeter-intro.html](http://www.bradapp.com/docs/demeter-intro.html)
- [13] Software Design Pattern, *Wikipedia* [http://en.wikipedia.org/wiki/Software_design_pattern](http://en.wikipedia.org/wiki/Software_design_pattern)
- [14] Design Patterns: Elements of Reusable Object-Oriented Software, *E. Gamma y otros*. ISBN 0201633612.
- [15] Refactoring to Patterns, *Josua Kerievsky*. ISBN 0321213351.
- [16] Refactoring: Improving the Design of Existing Code, *Martin Fowler*. ISBN 0201485672.




# Parte II: Aplicaciones. Refactoring y patrones.


## Refactoring básico

### Renaming

Tal vez el que más impacto tiene entre todas las técnicas de refactoring. Escoger bien los nombres de clases, métodos y variables puede parecer trivial pero no lo es tanto si queremos ser verdaderamente concisos y evitar ambigüedades. Los nombres deben cambiar también si la evolución del código los desvirtúa.

### Extract method

En este refactoring identificamos un bloque dentro de un método que tiene entidad por sí mismo y lo extraemos a otro método.

```php
<?php
// Extract method v1

class Bidder
{

    public function bid(BidInterface $bid)
    {
        if (!$bid->isPlaceable()) {
            $message = sprintf('The auction is closed to bids.');
            throw new InvalidBidException($message);
        }
        if (!$bid->isLowerThanAuction()) {
            $message = sprintf('It is not possible to place bids with an amount higher than current');
            throw new InvalidBidException($message);
        }
        if ($bid->needsBuyout()) {
            $bid->executeBuyOut();
            $this->stateMachine->execute(AuctionTransitions::ASSIGN, $bid->getAuction());
        }
        return $bid->execute();
    }
}

?>
```



```php
<?php
// Extract method v2

class Bidder
{

    public function bid(BidInterface $bid)
    {
        $this->assertValidBid($bid);
        if ($bid->needsBuyout())) {
            return $this->executeBuyOut($bid);
        }
        return $bid->execute();
    }

    private function assertValidBid(BidInterface $bid)
    {
        if (!$bid->isPlaceable()) {
            $message = sprintf('The auction is closed to bids.');
            throw new InvalidBidException($message);
        }
        if (!$bid->isLowerThanAuction()) {
            $message = sprintf('It is not possible to place bids with an amount higher than current');
            throw new InvalidBidException($message);
        }
    }

    private function executeBuyOut(BidInterface $bid) {
        $bid->executeBuyOut();
        $this->stateMachine->execute(AuctionTransitions::ASSIGN, $bid->getAuction());
    }
}
?>
```

Con extract method **aumentamos la legibilidad** del código, dado que asignamos nombres a cada bloque de código que denotan la intención. Es importante que, dentro de un método, todas las operaciones se ejecuten al mismo nivel de abstracción. Es decir, un mismo método no debería encargarse de realizar una operación matemática, utilizar un API externo y almacenar registros en base de datos. Estructurar los métodos según el nivel en el que operan ayuda a tener un código más coherente.


### Pull up method

Con pull up method adaptamos unificamos métodos muy similares de varias subclases en una misma superclase, reusando el código.

```php
<?php
// Pull up method v1

public class AgencyRepository {

    // ...

    private function resultsToAgencies(array $results) {
        $agencies = array();
        foreach ( $results as $result ) {
            $agencies[] = Agency::fromArray($result);
        }
        return $agencies;
    }
}


public class CustomerRepository {

    // ...

    private function resultsToCustomers(array $results) {
        $customers = array();
        foreach ( $results as $result ) {
            $customers[] = Customer::fromArray($result);
        }
        return $customers;
    }
}
?>
```


```php
<?php
// Pull up method v2

public class Repository() {

    private $modelName;

    public function __construct($model_name) {
        $this->modelName = $model_name;
    }

    private function resultsToInstances(array $results) {
        $instances = array();
        foreach ( $results as $result ) {
            $instances[] = $this->modelName::fromArray($result);
        }
        return $instances;
    }
}


public class AgencyRepository extends Repository {

    public function __construct() {
        parent::__construct('Agency');
    }

    // ...
}


public class CustomerRepository extends Repository{

    public function __construct() {
        parent::__construct('Customer');
    }

    // ...
}
?>
```

### Extract class

Extract class normalmente sucede tras un extract method. Ayuda a simplificar una clase extrayendo responsabilidades a un colaborador.

```php
<?
// Extract class v1

class CashMachine {

    private $ip;

    public function __construct($ip) {
        $this->ip = $ip;
    }

    public function withdraw() {
        $connection = $this->connect();
        // do whatever
    }

    private function connect() {
        // .
        // .
        // .
        // .
        // .
        // .
        // .
        // Something very loooong and complicated here
        return $connection;
    }

}
?>
```

```php
<?
// Extract class v2

class CashMachine {

    private $ip;
    private $connection;

    public function __construct($ip, Connection $connection) {
        $this->ip = $ip;
        $this->connection = $connection;
    }

    public function withdraw() {
        $connection->connect($this->ip);
        // do whatever
    }
}
?>
```






## Constructores

En el código orientado a objetos, las instancias concretas de cada abstracción se inyectan en las clases de menor nivel desde clases de nivel mayor.

Imaginemos la siguiente estructura:

![Mailing system](/images/orientacion_objetos_02_2014/mailers_constructors.jpg)

En el nivel superior de abstracción tenemos dos Mailers distintos, ambos compuestos por otra clase, llamada _ApplicationMailer_, que gestiona algunos requisitos de negocio. _ApplicationMailer_ se compone a su vez del mailer de sistema (pensad en PHPMailer o SwiftMailer como instancias concretas), abstraído por la interfaz SystemMailerInterface a modo de Adaptador. La construcción de emails es bastante compleja y por ello _ApplicationMailer_ se apoya en una clase auxiliar llamada _EmailBuilder_. Como los emails se construyen en base a plantillas, _EmailBuilder_ necesita además un componente encargado de _montar_ las plantillas sustituyendo los placeholders con los valores adecuados. Por último, al tratarse de un proyecto en evolución, las plantillas han pasado de almacenarse en la base de datos a guardarse en ficheros. Hay dos clases concretas encargadas de buscar las plantillas en el lugar adecuado, implementando la interfaz _TemplateFinderInterface_.

¡Un sistema bastante complejo!, ¿verdad?.

Resulta fácil imaginar el esfuerzo que supone construir cada instancia e inyectarla en los constructores adecuados. Tomemos como ejemplo la instanciación de EmployeeMailer.

```php
<?php
// Building a subsystem of collaborators

$template_finder = new TemplateFinder($path_to_templates);
$template_composer = new TemplateComposer($template_finder);
$email_builder = new EmailBuilder($template_composer, $global_variables);
$system_mailer = new PHPMailerAdapter(new PHPMailer);
$application_mailer = new ApplicationMailer($system_mailer, $email_builder);

// And finally...
$employee_mailer = new EmployeeMailer($application_mailer, $others, ...);
?>
```
El primer obstáculo al que se enfrentan los recién llegados a la programación a objetos es dónde situar el código de construcción de objetos.


### Opcion I: Contenedor de Inyección de Dependencias

Esta es la opción más costosa desde el punto de vista de la arquitectura del sistema, dado que se necesita configurar una herramienta concreta (el D.I.C) y exponerla al resto del sistema. Afortunadamente la mayoría de frameworks disponen de un D.I.C de serie.

```yaml
// Dependency Injection Container
parameters:
    path_to_templates: private/email-templates
    global_template_variables:
        #...

services:
    employee_mailer:
        class: Communication\Email\EmployeeMailer
        arguments: ["@application_mailer", ...]
    application_mailer:
        class: System\Mailer\ApplicationMailer
        arguments: ["@php_mailer_adapter", "@email_builder"]
    php_mailer_adapter:
        class: System\Mailer\PHPMailerAdapter
        arguments: ["@php_mailer"]
    php_mailer:
        class: PHPMailer
    email_builder:
        class: System\Mailer\EmailBuilder
        arguments: ["@template_composer", "%global_template_variables%"]
    template_composer:
        class: System\Templating\TemplateComposer
        arguments: ["@template_finder"]
    template_finder:
        class: System\Templating\FileTemplateFinder
        arguments: ["%path_to_templates%"]
```


Para instanciar el `EmployeeMailer` bastaría con requerir dicho servicio desde una clase con acceso al D.I.C.

```php
<?php
$employee_mailer = $container->get('employee_mailer');
?>
```

Aunque los contenedores de inyección facilitan las tareas de construcción de objetos, su objetivo no es ese. Un D.I.C. permite cambiar fácilmente la implementación concreta a utilizar de una abstracción. Por ejemplo, si tuviésemos dos sistemas utilizando la misma base de código, y en uno de ellos necesitásemos SwiftMailer y en el otro PHPMailer, tendría sentido declarar un único servicio y configurar cada entorno para que el D.I.C. devolviese la instancia apropiada.

```yaml
#more accurate usage of the DIC

# Environment a)
services:
    mailer_adapter:
        class: System\Mailer\SwiftMailerAdapter
        factory_class: System\Mailer\MailerAdapterFactory
        factory_method: create
        arguments:
            - "swiftmailer"


# Environment b)
services:
    mailer_adapter:
        class: System\Mailer\PHPMailerAdapter
        factory_class: System\Mailer\MailerAdapterFactory
        factory_method: create
        arguments:
            - "php"

```

Si registramos objetos como servicios de manera indiscriminada podemos incurrir en algunos problemas. Por una parte, la **abstracción** que proporciona un D.I.C. supone como contrapartida mayor **indirección** y código **menos explícito**. Para averiguar qué clases concretas se están utilizando en cada momento debemos buscar en los archivos de definición de servicios. Cuando estos archivos son demasiado grandes, encontrar esta información puede convertirse en un suplicio.


### Opcion II: Factory Class

Una opción muy extendida es utilizar una clase adicional, llamada normalmente **Factory**, responsable de la construcción de objetos.

```php
<?php
// Factory pattern

class MailerFactory {

    public static function create($type) {
        switch($type) {
            case 'php':
                return new \PHPMailer();
            case 'swiftmailer':
                // ...
                return new \Swift_Mailer(...);
            default:
                throw new \Exception("No definition found for mailer type $type");
        }
    }
}

$mailer = MailerFactory::create('php');
?>
```

El patrón Factory tiene como beneficio la **concentración del conocimiento de construcción en una sola clase**. Cuando esta lógica no es muy compleja, el uso de factories está menos legitimado pues **añade indirección** y **añade complejidad**.



### Opcion III: Factory Method

El uso de Factory Method está menos extendido que el de Factory Class, aunque en muchos casos presenta considerables ventajas. Una de las variantes consiste en situar el conocimiento de construcción en una **superclase** y ofrecer métodos distintos para cada **subclase**.

```php
<?php
// Factory method: superclass

class AbstractMailerAdapter {
    public static function createPHP() {
        return new PHPMailerAdapter(new \PHPMailer());
    }

    public static function createSwiftMailer() {
        return new SwiftMailerAdapter(new \SwiftMailer(...));
    }
}


$mailer = AbstractMailerAdapter::createPHP();
?>
```

Una de las aplicaciones más útiles de **Factory Method** es ofrecer un **constructor por defecto**. En la mayoría de los casos necesitamos inyección de dependencias (por testabilidad y diseño) pero sólo tenemos una implementación para cada una de las abstracciones. En este caso, el constructor por defecto es, en mi opinión, la estrategia más apropiada.


```php
<?php
// Factory method: default

public function ApplicationMailer {

    public function __construct(SystemMailerInterface $system_mailer, ...) {
        // ...
    }

    public function createDefault() {
        $system_mailer = new PHPMailerAdapter(new \PHPMailer);
        $email_builder = EmailBuilder::createDefault();
        return new static($system_mailer, $email_builder);
    }
}


$mailer = ApplicationMailer::createDefault();
?>
```

Uno de los puntos fuertes de este patrón es que se obtiene un **diseño muy sencillo**, dado que el conocimiento de construcción está en la propia clase. Además puede resultar muy potente al **encadenar métodos de construcción**. No resulta apropiado en sistemas muy complejos donde la flexibilidad es importante.


## Generalización

### Form Template Method

Este es un patrón que combina el refactoring pull-up method con polimorfismo. Se aplica cuando dos clases tienen un método muy similar, pero con pequeñas variantes.


```php
<?php
// Form Template Method v1

class CustomerRepository {

    public function fromRequest(Request $request, Request_Processor $processor) {
        $query_builder = new QueryBuilder( new Query_Wrapper );
        $query_builder->select('c.*')
            ->from('customers', 'c')
            ->join('agencies', 'a', 'c.agency_id=a.id');
        $processor->applyToBuilder( $request, $query_builder );
        return $query_builder->execute();
    }
}


class EmployeeRepository {

    public function fromRequest(Request $request, Request_Processor $processor) {
        $query_builder = new QueryBuilder( new Query_Wrapper );
        $query_builder->select('e.*')
            ->from('employees', 'e');
        $processor->applyToBuilder( $request, $query_builder );
        return $query_builder->execute();
    }
}
?>
```

```php
<?php
// Form Template Method v2

abstract class Repository {

    protected abstract function setBaseQuery( QueryBuilder $query_builder );

    public function fromRequest(Request $request, Request_Processor $processor) {
        $query_builder = new QueryBuilder( new Query_Wrapper );
        $this->setBaseQuery( $query_builder );
        $processor->applyToBuilder( $request, $query_builder );
        return $query_builder->execute();
    }
}


class CustomerRepository extends Repository {

    protected function setBaseQuery( QueryBuilder $query_builder) {
        $query_builder->select('c.*')
            ->from('customers', 'c')
            ->join('agencies', 'a', 'c.agency_id=a.id');
    }
}


class EmployeeRepository extends Repository {

    protected function setBaseQuery( QueryBuilder $query_builder) {
        $query_builder->select('e.*')
            ->from('employees', 'e');
    }
}
?>
```


### Unificar interfaces con Adapter

Utilizamos una clase adaptadora para permitir la sustitución de componentes sin afectar al resto del código.

![Adapter](/images/orientacion_objetos_02_2014/adapters.jpg)


### Interpreter

El patrón Interpreter sirve para evaluar sentencias en un lenguaje implícito. Por ejemplo, una clase que permitiese evaluar una expresión como la siguiente:

```php
<?php
// Interpreter
$sentence = "Roses are red, the sky is blue, and all your base are belong to us.";
$interpreter->execute($sentence);

array(
    'roses'         => 'red',
    'sky'           => 'blue',
    'all your base' => 'belongs to us'
);
?>
```

Para más ejemplos sobre evaluación de expresiones con interpreter, consultar tests de [QueryBuilder](https://github.com/carlescliment/query-builder/blob/master/tests/carlescliment/QueryBuilder/QueryBuilderTest.php#L155).


## Simplificación

### Command
El patrón command permite eliminar condicionales a través de un ejecutor y varios colaboradores (comandos).


```php
<?php
// Command v1

class PasswordValidator {

    const MIN_LENGTH = 8;

    public function validate($password) {
        if (strlen($password) < self::MIN_LENGTH) {
            return new InvalidValidation(sprintf('Password must contain at least %d chars', self::MIN_LENGTH));
        }
        if (!preg_match('/[A-Z]+/', $password)) {
            return new InvalidValidation(sprintf('Password must contain an uppercase'));
        }
        if (!preg_match('/[0-9]+/', $password)) {
            return new InvalidValidation(sprintf('Password must contain a number'));
        }
        // Many other validations
        return new ValidValidation();
    }
}
?>
```

```php
<?php
// Command v2

class PasswordValidator {

    private $rules = array();

    public function addRule(PasswordRule $rule) {
        $this->rules[] = $rule;
    }

    public function validate($password) {
        foreach ($this->rules as $rule) {
            $validation = $rule->validate($password);
            if ($validation->isInvalid()) {
                return $validation;
            }
        }
        return new ValidValidation();
    }
}

$validator = new PasswordValidator();
$validator->addRule(new PasswordRules\MinLength(8));
$validator->addRule(new PasswordRules\ContainsUppercase());
$validator->addRule(new PasswordRules\ContainsNumeric());
//
$validator->validate('my password');
?>
```

## Protección

### Null object

Null Object permite manejar las respuestas de una forma uniforme, sin condicionales:

```php
<?
// null object v1
$logger = $this->getLogger();
if ($logger) {
    $logger->log('All your bases are belong to us');
}
?>
```

```php
<?
// null object v2

class NullLogger {

    public function log($message) {
        return true;
    }
}


$logger = $this->getLogger();
$logger->log('All your bases are belong to us');
?>
```


Null Object es un patrón estupendo para cancelar procesos indeseados en entornos de testing (emails, transmisiones FTP, etc)...


## Recopilación

### Collecting Parameter

```php
<?php
// collecting parameter v1

class ScoreUpdater {

    public function update(Player $player, Stage $stage) {
        $score = 0;
        $score += $this->getMobKillingPoints($stage);
        $score += $this->getTravellingPoints($stage);
        $score += $this->getNPCInteractionPoints($stage);
        $score += $this->getItemPoints($stage);
        $player->addPoints($score);
        return $this;
    }
}
?>
```

```php
<?php
// collecting parameter v2

class ScoreUpdater {

    private $modifiers = array();

    public function addModifier(ScoreModifier $modifier) {
        $this->modifiers[] = $modifier;
    }

    public function update(Player $player, Stage $stage) {
        $score = new Score(0);
        foreach ($this->modifiers as $modifier) {
            $modifier->applyTo($score);
        }
        $player->addScore($score);
    }
}
?>
```



# ¡Y esto es todo por hoy!
