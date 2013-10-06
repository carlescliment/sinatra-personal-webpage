---
title: Otra manera de desarrollar en Drupal (y II)
date: 2012-05-07
---

_Nota: este artículo forma parte de una serie de dos, y aunque no es
imprescindible os recomiendo que leáis [la primera
parte](http://www.carlescliment.com/blog/otra-manera-desarrollar-drupal-i) en
la explico mis motivaciones a la hora de cambiar mi manera de trabajar con
Drupal._

Como os comentaba, mis condiciones para continuar desarrollando en este CMS
eran que éste se adaptara a mis necesidades como desarrollador. Tuve la
oportunidad de tomar nuevas perspectivas en un rápido paseo por Symfony,
Django y Ruby on Rails, y quise aprovechar esas experiencias en un proyecto
nuevo sobre [una web](http://www.poker-red.com/) que había evolucionado desde
Drupal 4 a Drupal 6. Una web legacy es un entorno ideal para hacer
experimentos, porque difícilmente la vas a dejar peor de lo que está. Dicho
esto, es hora de entrar en materia. Manos a la obra.

## MVC

El patrón MVC se basa en separar la lógica de negocio (modelo) de cómo ésta va
a ser representada (vista). Para conseguirlo, es necesario un controlador que
haga de mediador y proporcione a la vista los datos necesarios a partir del
modelo.

En Drupal estamos acostumbrados a una estructura a medio camino del MVC. Los
buenos programadores en Drupal se cuidan mucho de aislar sus plantillas
(vista) de la lógica de negocio. Por otra parte tenemos archivos `.module`,
`.pages.inc` y `.admin.inc`, que son una mezcla de controlador y modelo.
Dependiendo de lo disciplinado que uno sea esta mezcla estará más o menos
batida, pero en general resulta difícil identificar qué funciones acarrean la
lógica de negocio y cuáles se encargan de articular las respuestas al usuario.

#### El modelo

Teniendo como referencia los frameworks comentados en el segundo párrafo quise
llevarme el patrón MVC a Drupal y añadí a los consabidos archivos `.inc` y
`.module` un directorio `models/` donde incluiría las clases que formarían
parte del modelo. Para identificar cuáles son estas clases basta con hablar
con el cliente y ver qué términos utiliza. En mi caso eran algunos como
Torneo, Liga, Calendario, Sala de Poker, Jugador, Ranking o Premio. Esto nos
da una pista de cuáles tienen papeletas para ser las clases que van a
representar el ámbito de negocio. Cada una de estas entidades está reflejada
en una clase en su correspondiente archivo PHP dentro del directorio models.
Por supuesto, para relacionarse entre sí estas clases necesitan
**colaboradores** que nos ayudan a mantener el [principio de una sola
responsabilidad](http://en.wikipedia.org/wiki/Single_responsibility_principle)
y a encapsular el código. Estos colaboradores también son clases que forman
parte del modelo. Todo lo que tenga que ver con la lógica de negocio y la base
de datos se controla desde aquí.

#### La vista

El sistema de plantillas de Drupal es lo bastante bueno como para no añadir
nada más. Lo compro tal y como está, con la sola diferencia de guardar todas
las plantillas en un directorio `views/`. Es más, me gusta tanto que **no
renderizo nada si no es mediante su propio theme()**, con la excepción de los
formularios. Ninguna función debería devolver HTML si seguís la metodología de
desarrollo que os propongo. Aunque esto nos lleve a un `hook_theme()` de más
de 15 items y sus correspondientes plantillas, no veo nada malo en ello. Eso
sí, cuidad bien los nombres de los items y sus plantillas, porque si no sois
cuidadosos os va a costar encontrar esa plantilla que renderizaba el
componente que andáis buscando. Por supuesto, intentad no meter condicionales
en las plantillas, más allá de los consabidos `if(isset())`, aunque si os soy
sincero yo mismo me he saltado esa norma plantando un
`if(user_is_logged_in())`. Vosotros mismos.

#### El controlador

Aquí es donde Drupal brilla con todo su potencial. En el controlador
(`.module`) incluiremos todos los hooks y las funciones `_preprocess()` de
nuestros items definidos en el `hook_theme()`, además de los `_form()` que
irán en los `pages.inc` o `admin.inc`.Si queremos mantener cachés estáticas
para mejorar el rendimiento las meteremos también aquí. Las variables
estáticas dan muchos problemas durante el testing, y así mantendremos nuestras
clases libres de esta capa de cacheo. Nuestras funciones preprocess y hooks
deberían ser ahora muy ligeritos, ya que se limitarán a instanciar objetos e
invocar a sus métodos en función de las acciones del usuario y de las
necesidades de la vista.

## Orientación a objetos

Una vez escuché que Drupal sí es orientado a objetos porque `$user` y `$node`
son objetos y porque tenemos `db_fetch_object()` a nuestra disposición.
Siguiendo ese razonamiento, podríamos también decir que Drupal es _orientado a
arrays_ porque devolvemos arrays en el `hook_menu()`, `hook_block()` o
`hook_schema()`. Por supuesto no existe tal cosa como programación orientada a
arrays, y tampoco existe orientación a objetos en Drupal por mucho que castee
un array a objeto.

Los objetos parten como abstracciones de la realidad y además de estado
presentan comportamiento. A través del refactoring, nuestras clases tal vez se
vayan descomponiendo en otras más pequeñas y vayan creando delegados que les
ayuden a hacer tareas secundarias. La programación orientada a objetos supone
también que los objetos se comunican entre sí mediante el paso de mensajes.
Resumiendo a lo esencial, estaremos utilizando orientación a objetos cuando
establezcamos una comunicación (a través de su interfaz) entre las instancias
que representan a las entidades del modelo de negocio.

#### La base de datos

Uno de los desafíos más importantes a los que me enfrenté fue la gestión de la
persistencia. La solución que finalmente adopté no se pareció en nada a la que
inicialmente había pensado, y emergió por sí misma a traves de los continuos
refactorings del ciclo de TDD. Os cuento el proceso.

Mi intención inicial era que las clases principales no supiesen nada sobre
persistencia. Que les diese lo mismo si iban a ser almacenadas en una base de
datos relacional o en una hoja excel. Para ello, cada clase necesitaba una
clase hermana (a la que llamé `Persistor`) que sí sabía cargar y guardar
instancias. Por ejemplo, la clase `Tournament` tendría una colaboradora
llamada `TournamentPersistor` con la que se podía comunicar. Como quería
mantener oculta la la implementación de la clase, todos sus atributos eran
privados. Esto significa que para guardar un torneo hacía algo parecido a
esto:

`$tournament->saveWith($tournamentsPersistor);`

Entonces la comunicación entre las dos empezaba. Como los atributos de
`$tournament` eran privados, éste exponía sus datos creando un
[DTO](http://en.wikipedia.org/wiki/Data_transfer_object) de sí mismo y se lo
enviaba al `Persistor`. El persistor hacía las queries necesarias y devolvía
el identificador. Si la instancia era nueva (era la primera vez que se
almacenaba), el torneo actualizaba su campo id con el valor devuelto por el
persistor. Fácil, ¿no?.

Bien, pues a medida que desarrollaba me di cuenta de algunas cosas que no me
gustaban nada. Por ejemplo, que era un coñazo crear un persistor por cada
clase que necesitase persistencia. Otro problema es que cuando añadía un
atributo a la clase que necesitase ser persistido, tenía forzosamente que
añadir este atributo al DTO. Mis clases eran todas muy simples, y al final
todas acababan en su propia tabla y eran almacenadas mediante
`drupal_write_record()`. Como os podéis imaginar la replicación del código era
creciente, pero por suerte me vinieron muy a mano los conocimientos adquiridos
durante un desarrollo reciente en Ruby On Rails y acabé generalizando código y
formando un [ORM](http://en.wikipedia.org/wiki/Object-relational_mapping)
basado en [ActiveRecord](http://en.wikipedia.org/wiki/Active_record). Ya hubo
antes quien hizo sonar estas campanas, como se demuestra en [este
enlace](http://groups.drupal.org/node/8001) vía [Alessandro Mascherpa
(@almadeweb)](http://almadeweb.es/) (¡gracias!).

#### Active Record

Una vez implementado ActiveRecord, que se basa en el `hook_schema()` y en la
[metaprogramación](http://en.wikipedia.org/wiki/Metaprogramming), mis clases
persistidas pasaron a heredar de esta. Esto tuvo su parte buena y su parte
mala. Por ejemplo, ActiveRecord te obliga a mantener un identificador único
(ID). Si antes necesitabas una clave primaria múltiple, ahora tenías un ID y
una clave única que sustituiría a la anterior clave primaria. Por supuesto,
utilizar ActiveRecord implica exponer al completo los atributos de tu clase,
pero teniendo en cuenta que estos atributos iban a ser necesitados por las
plantillas (a través de DTOs) tampoco me parecía grave exponerlos. Evaluando
los pros y contras, creo que salí ganando. Eliminé la duplicidad y simplifiqué
tremendamente el código.

Podríamos filosofar mucho sobre las bondades y vilezas de ActiveRecord. Que
quede claro que no soy ningún fan de este patrón de diseño, y de hecho en el
[proyecto previo](http://www.pokerpromanager.com/) en Ruby on Rails lo
descarté en favor del [ORM DataMapper](http://datamapper.org/). Pero **en este
caso me venía como anillo al dedo**.

La versión de ActiveRecord de Drupal 6 surgió a través de refactorings y
generalizaciones de las clases Persistor existentes, y no quedó del todo a mi
gusto. Quedó lo suficientemente fea para que no la quiera compartir con
vosotros (al menos por el momento). Pero me pareció un invento lo bastante
bueno como para portarla a Drupal 7: [ActiveRecord for Drupal
7](https://github.com/carlescliment/ActiveRecord). Podéis descargárosla, echar
un vistazo al fuente y trastear con ella cuando gustéis. Eso sí, sin muchas
más garantías que el haberla programado con todo el amor del que he sido
capaz, pero tened en cuenta que la versión en Drupal 7 aún no ha salido del
laboratorio, está a medias y no andará libre de bugs. ¡Andáos con ojo!

## BDD

Nunca me gusta dejar el testing para el final, pero es el aspecto de mi serie
de cambios cuyas conclusiones son más difusas. Hablemos un poco sobre BDD y
comentemos las herramientas utilizadas, y la experiencia de trabajar con
ellas.

BDD (Behaviour-Driven-Development) es considerado una evolución de TDD (Test-
Driven-Development). Parte de la idea de que el testing con TDD ha sido muy
difícil de conculcar porque la gente no entendía el propósito verdadero del
desarrollo guiado por tests. Y es que es esa misma palabra, _"tests"_, la que
crea confusión e interferencias.

El objetivo real de los tests no es probar nada, sino expresar cómo se
comportan nuestras entidades a través de ejemplos. Es decir, que el testing se
convierte en nuestra especificación, nuestra prueba, y nuestra demostración de
que el código ofrece el comportamiento esperado a través de las interacciones
con otros componentes y con el usuario. BDD sirve además para desarrollar
exclusivamente el código necesario y nada más, ya que se desarrolla a partir
de la perspectiva de los usuarios.

De nuevo fue gracias a Ruby on Rails y a [Cucumber](http://cukes.info/) que
entré en contacto con los frameworks de testing en BDD, y de nuevo me los
quise llevar a Drupal mediante [Behat](http://behat.org/), el framework BDD
para PHP.

#### Behat

Behat, al igual que Cucumber, se sirve del [lenguaje
Gherkin](https://github.com/cucumber/cucumber/wiki/Gherkin) para describir los
ejemplos. Dispone de hooks similares al `setUp()` de Simpletest, por lo que
resulta sencillo levantar el bootstrap de Drupal y disponer de todas las
funciones de nuestro site. Behat es muy útil para hacer tests _de ciclo
largo_, por ejemplo aquellos que se apoyan en la interfaz, pero es demasiado
difuso para utilizarlo en tests unitarios. Utilizar Behat me supuso algunos
problemas. No dispone de una integración tan completa con Drupal como
SimpleTest y, entre otras cosas, me obligaba a mantener constantemente una
base de datos de testing apunto donde ejecutar los test. Aunque empecé muy
fuerte con Behat, cuando me vi incapaz de hacer un Post sobre Drupal con un
navegador virtual decidí abandonarlo en favor de SimpleTest. Es mi espina
clavada y pienso volver a la carga.

#### Simpletest

Todos conocemos esta adaptación del framework de testing de PHP, que ha sido
injertada como módulo en drupal 7 y portada a Drupal 6. Debido a sus múltiples
contras ya comentados en la primera parte de este artículo, limité los tests
con SimpleTest a lo mínimo exigible. Básicamente a probar el controlador y
algunas partes fundamentales de la vista ejercitando la web a través de la
interfaz, y siempre guiándome por los [tests de
aceptación](http://en.wikipedia.org/wiki/Acceptance_testing) definidos en las
historias de usuario. Ni un solo test de más que no fuera un test de
aceptación. De cómo ejercitaba el modelo hablaremos más adelante.

Es importante destacar algunos cambios que hice sobre mi propia forma de
testear con SimpleTest mis módulos de Drupal. Por ejemplo, tiré a la basura la
[solución que yo mismo recomendé hace unos meses para acelerar los tests de
Drupal](http://www.carlescliment.com/blog/el-sandbox-de-simpletest-en-drupal),
y que consistía en utilizar un solo testCase del cual _colgaban_ todos los
tests, ejecutándose un solo `setUp()`. En serio, es una mala solución, y me
maldigo a mí mismo por haberla sugerido. Los tests [deben ser
independientes](http://pragprog.com/magazines/2012-01/unit-tests-are-first), y
utilizando un solo `setUp()` estamos rompiendo esa independencia. En lugar de
esta solución, fragmenté mis tests en varios archivos, de manera que cada
archivo se encargaba de ejercitar funcionalidades diferentes con unos pocos
test cases.

Otro de los cambios que introduje fue la manera en que escribía cada test
case. Como bien apuntó [Emma López](http://agilismo.es/emma-lopez/) en su
charla sobre metodologías ágiles en el Drupal Day Valencia 2012, los tests con
Drupal son #toomuch #toolong #toodeep. Si queréis ver el régimen intenso al
que he sometido a mis tests de Drupal, lo comprobaréis en [los test sobre la
clase ActiveRecord.](https://github.com/carlescliment/ActiveRecord/blob/master
/activerecord/activerecord_testing/tests/activerecord.test)

#### PHPSpec

Aquí es donde viene el gran cambio. El cambio que me permitió mejorar mi
manera de desarrollar en Drupal. Porque ahora que estaba utilizando
orientación a objetos podía utilizar este magnífico [framework de unit-testing
con bdd](http://www.phpspec.net/) para ir construyendo mis modelos y
definiendo su comportamiento. ¡Ya podía utilizar [mocks y
stubs](http://martinfowler.com/articles/mocksArentStubs.html) cuando
quisiese!. Echadle una ojeada. Instaladlo, probadlo. No os defraudará
(próximamente un guía en este mismo blog).

