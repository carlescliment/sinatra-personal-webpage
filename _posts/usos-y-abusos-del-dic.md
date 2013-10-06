---
title: Usos y abusos del DIC
date: 2013-09-06
---

_Nota: Aunque en este artículo utilizo el término DIC (Dependency Injection
Container), en Symfony es más común la expresión [Service
Container](http://symfony.com/doc/current/book/service_container.html)._

### Introducción

Hace unas semanas, [mi amigo Edu](https://twitter.com/esclapes) me envió
información sobre [Laravel](http://laravel.com/docs), un nuevo framework que
ha irrumpido en el panorama de PHP con bastante fuerza. Laravel apuesta por la
simplicidad, emulando en gran medida a Rails en su sintaxis. Incluso su ORM
por defecto, Eloquent, está basado en el patrón ActiveRecord.

    
    
    $user = User::find(1);
    

Edu también me envió material sobre [Aspect
Mock](https://github.com/Codeception/AspectMock). Dado que Laravel se apoya en
invocaciones estáticas, es necesario incorporar herramientas como esta para su
testabilidad. En un [post de los creadores de
Codeception](http://codeception.com/07-31-2013/nothing-is-untestable-aspect-
mock.html) se defendía el uso de las llamadas estáticas y se decía que la
inyección de dependencias podía usarse como "un rodeo para testear PHP debido
a las limitaciones del lenguaje".

Entonces, dado que con esta nueva herramienta podemos probar invocaciones
estáticas, ¿seguimos necesitando inyectar objetos?

En mi opinión, los autores del post estaban simplificando los fines de la
inyección de dependencias para justificar su framework. La inyección de
dependencias no tiene como fin la testabilidad de aplicaciones, sino la
consecución de un diseño flexible, que cumpla con los principios S.O.L.I.D, y
que ofrezca sistemas extensibles, mantenibles y desacoplados. Pero indagando
un poco por la red, algunos comentarios que se referían a _abusar del DIC_ me
hicieron reflexionar. ¿Cuándo se abusa?. ¿Cómo y dónde debo utilizar el DIC?
¿Tienen parte de razón los que muestran sus reservas?.

En este post no voy a escribir sobre la inyección de dependencias. Tenéis
abundante material sobre ello en la red. A quienes no tuvisteis la oportunidad
de acudir al deSymfony de este año os recomiendo la [charla de Gonzalo
Ayuso](http://desymfony.com/ponencia/2013/inyeccion-dependencias-aplicaciones-
php) en la que abarca todo este asunto con impecable claridad. En cambio os
hablaré de mi experiencia con el Contenedor de Inyección de Dependencias de
Symfony 2 y de algunas conclusiones que he podido extraer sobre los usos y
abusos del DIC.

### Para qué sirve el DIC

Si eres desarrollador de Symfony, seguramente conoces el componente
DependencyInjection y lo utilizas en mayor o menor medida en tus aplicaciones.
El DIC te permite "publicar" algunas de tus clases como servicios, que pueden
ser utilizados a su vez por cualquier otra clase que tenga acceso al DIC.

Pero, ¿cuándo debemos definir una clase como servicio?

La respuesta más evidente es: cuando queremos que una clase o instancia esté
disponible para cualquier otra instancia con acceso el DIC. Pero... ¿no es lo
que acabo de decir un poco más arriba?. Sí, en efecto, pero no es tan trivial
como parece.

Un buen ejemplo de servicio es, por ejemplo, el Event Dispatcher. Es muy
probable que algún componente quiera comunicar un evento, por lo que tiene
mucho sentido que el Event Dispatcher sea un servicio. También tiene sentido,
por ejemplo, que lo sea el Entity Manager. Pero esto son servicios del propio
framework. ¿En qué supuestos voy a querer publicar un servicio de **mi
aplicación**?.

Uno de los usos que encuentro más prácticos del DIC es **proporcionar una capa
de abstracción** que favorezca que los componentes de la aplicación no se
conozcan entre sí. El ejemplo más claro que se me ocurre es el de los
controladores.

    
    
    // controller
    
        /**
         * @ParamConverter("course", class="MetodicsSchoolBundle:Course")
         * @Template()
         */
        public function signUpAction(Course $course, Request $request)
        {
            $signup = new SignUp($course);
            $form = $this->createForm(new SignupType, $signup);
            $form->bind($request);
            if ($form->isValid()) {
                try {
    	        $this->get('signup_handler')->handle($signup);
                    $message = 'Your signup has been successfully completed.';
                }
                catch (Exceptions\AlreadyPreinscribedException $e)
                {
                    $message = sprintf('Ohps. Your email was already inscribed.', $signup->getEmail());
                }
                $this->get('session')->setFlash('notice', $message);
                return $this->redirectToCourse($course);
            }
            return array('form' => $form, 'course' => $course);
        }
    
    
    
        // services.yml
    
        signup_handler:
            class: Metodics\SchoolBundle\Model\Course\SignUpHandler
            arguments: ["@signup_validator", "@signup_persistor"]
    

En el ejemplo de arriba estamos utilizando un servicio 'signup_handler'. El
controlador no sabe qué clase en concreto se encarga de gestionar el registro.
Introducir esta capa de abstracción permite desacoplar el controlador de las
clases que implementan la lógica de negocio. Esto permite modificar
posteriormente el comportamiento de la aplicación sin tener que modificar el
controlador, además de otras ventajas como liberar al controlador de resolver
las dependencias del servicio.

Otro de los grandes beneficios del DIC es **ofrecer comportamientos distintos
para distintos entornos**. Imaginad que tenemos una misma aplicación para
distintos clientes que envían notificaciones a su base de datos de usuarios.
Algunos clientes comunican por email, y otros prefieren hacerlo por SMS. El
DIC nos permite ofrecer ambos comportamientos con la misma base de código:

    
    
    // config_foo_client.yml
        communication_handler:
            class: Metodics\SchoolBundle\Model\Difusion\SMSHandler
            arguments: ["@sms_bridge"]
    
    
        // config_bar_client.yml
        communication_handler:
            class: Metodics\SchoolBundle\Model\Difusion\EmailHandler
            arguments: ["@swiftmailer"]
    

### Abusando del DIC

Es fácil enamorarse del DIC. Con él conseguimos código mucho más limpio y
favorecemos un estilo de programación basado en componentes que colaboran
entre sí. Pero el uso del DIC no está exento de riesgos. Volvamos a los
ejemplos anteriores.

Hemos dicho que invocando servicios nos ahorramos conocer e instanciar las
dependencias de dichos servicios. ¡No hay 'new's en nuestro código!. ¿Pero de
verdad no hay 'new's? Por supuesto que los hay, lo que pasa es que los realiza
el propio componente DependencyInjection. Pero para que esto ocurra tenemos
que afrontar una seria contrapartida; todas y cada una de las dependencias y
subdependencias tienen que estar definidas como servicios.

Entonces, ¿está justificado publicar una clase como servicio porque a su vez
es una dependencia de otro servicio?. En mi opinión, no. Si tomamos como
práctica habitual el uso de servicios desde los controladores, a medida que
nuestro sistema crezca iremos añadiendo más y más dependencias al contenedor.
En un sistema medianamente complejo, los archivos de definición de servicios
pueden volverse inmanejables muy pronto. Sí, es cierto, ganamos la
flexibilidad de cambiar cada dependencia fácilmente, pero **la publicación de
una dependencia como servicio debería ser consecuencia de las necesidades de
la aplicación**. Es decir, cada vez que vayamos a publicar un servicio debemos
preguntarnos: ¿está justificado? ¿Voy a tener que ofrecer distintos
comportamientos en distintos entornos? Si no es así, el hecho de poder cambiar
el componente fácilmente, dejando el anterior como un vestigio inerte, no
tiene sentido.

Cuando caemos en el abuso del DIC - o al menos cuando lo hago yo - es
normalmente porque estamos utilizándolo como Factory. Este patrón está muy
bien, pero el DIC no es el lugar apropiado para implementarlo. Por ejemplo,
imaginemos que tenemos la siguiente configuración en una aplicación:

    
    
    // services.yml
        report_formatter:
            class: Metodics\InvoicesBundle\Model\Report\Formatter
    
        taxes_report:
            class: Metodics\InvoicesBundle\Model\Report\TaxesReport
            arguments: ["@doctrine.orm.entity_manager", "@report_formatter"]
    
        wages_report:
            class: Metodics\InvoicesBundle\Model\Report\WagesReport
            arguments: ["@doctrine.orm.entity_manager", "@report_formatter"]
    
        income_report:
            class: Metodics\InvoicesBundle\Model\Report\IncomeReport
            arguments: ["@doctrine.orm.entity_manager", "@report_formatter"]
    

Con esta configuración podemos obtener cualquier informe desde un controlador
con `$this->get('xxx_report')`. Pero en casi todos los supuestos, este es un
mal uso del DIC porque expone servicios que no tienen por qué estar expuestos
directamente. El DIC no está pensado para construir objetos, y para ello
podemos implementar nuestro propio Factory:

    
    
        report_factory:
            class: Metodics\InvoicesBundle\Model\Report\ReportFactory
            arguments: ["@doctrine.orm.entity_manager"]
    

Será este factory el encargado de gestionar las dependencias, aliviando el
DIC. Si más adelante necesitamos ofrecer comportamientos distintos en los
informes, será entonces cuando debemos plantearnos su publicación como
servicios.

Lo mismo podemos decir del ejemplo del formulario de registro. El DIC puede
tener un aspecto similar:

    
    
        signup_persistor:
            class: Metodics\SchoolBundle\Model\Course\SignUpPersistor
            arguments: ["@doctrine.orm.entity_manager"]
    
        signup_validator:
            class: Metodics\SchoolBundle\Model\Course\SignUpValidator
            arguments: ["@doctrine.orm.entity_manager"]
    
        signup_handler:
            class: Metodics\SchoolBundle\Model\Course\SignUpHandler
            arguments: ["@signup_validator", "@signup_persistor"]
    

Si esto ocurre para un solo formulario, imaginad cuando tengamos más de
veinte. Tal vez sea más conveniente ofrecer un único servicio que se encargue
de devolver el handler apropiado para cada formulario:

    
    
    handler_factory:
            class: Metodics\SchoolBundle\Model\Handler\HandlerFactory
            arguments: ["@doctrine.orm.entity_manager"]
    

Y en el controlador algo como
`$this->get('handler_factory')->build('SignUp');`

### Conclusiones

Hace muy poco que he tenido la revelación de que estaba utilizando mal el DIC,
en parte gracias a los materiales que me envió Edu, y tal vez queden muchos
otros casos de mal uso que no han quedado expuestos. En cualquier caso, la
superpoblación de servicios en el DIC es un bad smell, y su sustitución por
clases Factory me parece una buena aproximación. Por el momento

Tal vez en el futuro pueda extender este post con nuevas reflexiones. Estaré
encantado si me ayudáis a conseguirlo con vuestros comentarios.

