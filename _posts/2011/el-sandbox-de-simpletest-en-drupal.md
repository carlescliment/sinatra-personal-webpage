---
title: El sandbox de Simpletest en Drupal
date: 2011-12-15
---

### El clon

Ayer apareció en el blog de Ben Buckman un artículo titulado [Unconventional
unit testing in Drupal 6 with PhpUnit, upal, and
Jenkins](http://benbuckman.net/tech/11/12/unconventional-unit-testing-drupal-6
-phpunit-upal-and-jenkins).

Este artículo, estupendamente redactado, proponía una nueva manera de testear
las webs en Drupal utilizando [phpUnit](http://en.wikipedia.org/wiki/PHPUnit)
y [Upal](http://www.acquia.com/upal), el framework de testing de Aquia para
Drupal. Un título muy convincente.

Ben Buckman introduce su artículo comentando los problemas de rendimiento de
los tests de integración de Drupal. Problemas que comparto y que suponen tal
quebradero de cabeza que se han convertido en una amenaza de divorcio con este
gestor de contenidos. La solución que propone pasa por evitar la creación y
destrucción del sandbox que ocurre en cada caso de pruebas utilizando un clon
de la base de datos del desarrollador. El sandbox es la reproducción en la
base de datos de un entorno Drupal, el
[SUT](http://en.wikipedia.org/wiki/System_Under_Test), completamente limpio en
el que podemos instalar desde cero los módulos necesarios y crear una muestra
inicial.

Da la casualidad de que esta misma semana descubrí un vídeo de la charla sobre
[Unit&Integration Testing](http://www.livestream.com/emision_en_directo/video?
clipId=pla_3d1f2fb9-a883-4957-9328-817113786d12), ofrecida en la DrupalCamp
2010 por Javier Carranza, del equipo de [Alquimia Proyectos
Digitales](http://al.quimia.net/). Javier presentaba una solución parecida.
Crear un clon de la base de datos utilizando la clase
_SimpleTestCloneTestCase_.

### Mis objeciones

Me sorprendió encontrarme en tan poco tiempo con dos aproximaciones a esta
solución. A pesar de los problemas de rendimiento derivados de mantener el
sandbox, soy de los que piensan que es absolutamente necesario. Para que el
testing sea efectivo, es imprescindible conocer con exactitud cuáles son las
condiciones sobre las que se ejecutan las pruebas. En un entorno vivo como una
base de datos real (o una copia de ella), la muestra es cambiante. No podemos
asegurar que las condiciones son las esperadas y, por lo tanto, estamos
condicionando las pruebas. **La muestra inicial debe ser siempre la misma para
crear siempre las mismas condiciones y obtener los mismos resultados**.

Voy a intentar exponer mi argumento con unos casos prácticos:

  * Ejecutando exactamente el mismo código con bases de datos de dos días distintos podríamos obtener distintos resultados. Por ejemplo, el test podría fallar si uno de los nodos a los que acudimos en los test ha sido borrado. Hay mil condicionantes que pueden hacer fallar cualquier test. Peor aún, un test podría pasar como bueno porque en ese momento&nbsp_place_holder;la base de datos le ofrece las condiciones exactas para que pase.
  * En su artículo, Ben comenta que los métodos drupalCreateNode() y drupalVariableSet() han sido modificados para que permitan limpiar los datos creados durante las pruebas. ¿Y qué ocurre con los datos de tablas generadas por los módulos? ¿Qué pasa si nuestro módulo inserta en una tabla propia un registro con una clave ajena&nbsp_place_holder;a un nodo, y en el tearDown() no lo elimina? La segunda vez que se ejecute el test el registro ya estará creado y la query nos devolverá un error.
  * ¿Como probamos la instalación de un módulo (hook_install()) si en nuestra base de datos ese módulo ya ha sido instalado? ¿Tenemos que gestionar constantemente la destrucción y creación de tablas?


Algunos de estos problemas son solventables con una microgestión exhaustiva de
las tablas y registros creados, pero al final vamos a terminar haciendo más
trabajo que la creación del sandbox.

### Nuestra experiencia

Personalmente creo que la solución no pasa por ahí. Drupal parte de una
arquitectura que le hace depender abusivamente de la base de datos. Este
hecho, y el agravante de que hasta ahora se ha huído de la programación
orientada a objetos, ha provocado que los módulos de Drupal sean casi
intratables desde tests unitarios. Además, el controlador de Drupal y los
módulos están fuertemente acoplados, por lo que es necesario levantar el
framework completo si queremos observar el comportamiento del sistema de
manera realista.

Los programadores PHP estamos mal acostumbrados (alguien querrá estirarme las
orejas aquí). Tendemos a crear múltiples dependencias de unos módulos sobre
otros, por lo que el flujo de ejecución se dispersa por todas las esquinas de
la aplicación. Estas dependencias obligan a levantar multitud de módulos en el
setUp() de un test, lo que incrementa considerablemente el tiempo de
construcción del sandbox.

En **Aureka Internet** llevamos más de un año tomándonos el testing muy en
serio, y hemos llegado a unas soluciones que nos permiten ir tirando. A pesar
de que algunos test de un módulo tardan 30 segundos (nuestro umbral máximo,
una aberración), nunca hemos renunciado al sandbox. La primera solución pasa
por crear **una única muestra por test**. Un sólo método test que invoca a
muchas otras funciones que hacen sus distintos asserts:

    function testWrapper() {
        $this->checkAccessGrants();
        $this->checkModuleSetup();
        $this->checkCreateContent();
    }

De esta manera se ejecuta sólo un setUp() y solo un tearDown(). La
contrapartida es que los test no son independientes entre sí, por lo que
documentamos exhaustivamente la muestra inicial y los estados en los que ésta
queda tras cada test.

El siguiente paso, que aún no hemos puesto en práctica, es empezar a utilizar
programación orientada a objetos y aislar la lógica de negocio en ella. La
interacción con Drupal y con la base de datos se lleva en los hooks, que
instancian objetos que reciben inputs y devuelven outputs. Pensamos que de
este modo conseguiremos desviar la mayoría de los tests realizados con
DrupalWebTestCase a la clase DrupalUnitTestCase, mucho más rápida.

Consideramos que el testing unitario y la TDD son tan importantes que, si no
conseguimos una manera efectiva de testear con Drupal, no nos quedará más
remedio que buscarnos un sustituto más eficaz.

