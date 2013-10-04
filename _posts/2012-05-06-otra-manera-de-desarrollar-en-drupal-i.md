--- layout: default title: Otra manera de desarrollar en Drupal (I) created: 1336295664 --- 

### De por qué me siento un extraño

En el último año me he estado introduciendo bastante en la comunidad Drupal y
he podido aprender muchísimo de mis compañeros, aportar mi granito de arena y
compartir multitud de experiencias con los demás. Pero cuando acudo a los
eventos y me encuentro con auténticos maestros de Views, Panels, Features o
Rules me siento tan extraño como un mono en el zoo de la ciudad. Porque todas
esas herramientas, por mucho que intento entenderlas, ni me motivan ni me
interesan, ni tienen visos de llegarme a interesar.

No uso Views porque me gusta controlar las queries que escribo. Porque cuando
busco en el mysql-slow.log quiero poder [optimizar las más
lentas](http://groups.drupal.org/node/131949) con facilidad. No uso Panels
porque tengo un [compañero y maquetador excelente](http://marcos-
calatayud.com/), al que le gustan los detalles y no quiere HTML ni CSS de más.
No uso Features ni Rules porque odio tanto el código autogenerado como que la
lógica de negocio esté en la base de datos. No uso todo eso porque todo lo que
me ofrecen ya lo puedo hacer con estas dos manos y un teclado.

De todas esas herramientas no entiendo ni papa y en cambio me gusta hablar de
encapsulamiento, de complejidad ciclomática, de semántica y abstracción, de
testing y refactoring. Y cuando hablo de todo esto muchos abren los ojos como
platos y me miran raro, y a mí me entra el complejo y pienso que a lo mejor es
que he dicho algo mal.

Y no es eso. Es que parece que lleve escafandra y acabe de aterrizar en una
nave espacial. Pero no soy yo, ¡no soy yo!, es la comunidad Drupal la que está
mal. Todo lo que digo no es más que el ABC de nuestra profesión, no pretendo
erigirme como el [Michael
Feathers](http://www.objectmentor.com/omTeam/feathers_m.html) valenciano, pero
cuando destapo [el código fuente de algún módulo](http://www.drupalcode.com/ap
i/function/advanced_forum_treat_as_forum_post/contrib-6.x-1.x) o [del core](ht
tp://api.drupal.org/api/drupal/modules%21comment%21comment.module/function/com
ment_render/6) me entran náuseas y mareos y pienso que voy a vomitar.

### Del testing en Drupal

Si eres desarrollador Drupal es posible que esto del testing solo te venga de
oídas, o lo practiques ocasionalmente y seguramente lo harás al final. Si no
es así, si piensas que el testing es la raíz de todo desarrollo, la
herramienta que nos permite diseñar correctamente nuestro código, nuestra
documentación y nuestra red de seguridad, entonces eres de los míos.

De todos los desarrolladores Drupal que conozco, tal vez menos del 20% se
tomen el testing en serio. Y de ese 20%, tal vez todos lo estemos haciendo
mal. En parte es por nuestra culpa y en parte es por culpa de Drupal.

Drupal ha sido escrito a voleo, a salto de mata, como mandan los cánones en
[la cultura de PHP](http://www.w3schools.com/php/func_string_strcmp.asp). Para
bien o para mal, los desarrolladores solemos hacer como los niños y
mimetizamos lo que vemos. Si a nuestro alrededor hay oro, creamos oro. Si a
nuestro alrededor hay mierda, producimos mierda. Y en Drupal no hay mucho oro
que encontrar.

¿Habéis intentado hacer unit testing en Drupal? Si no lo habéis hecho, os
animo a que lo intentéis. Y ya me contáis cuánto tardáis en encontraros con un
acceso inesperado a la base de datos, con un drupal_goto(), con una función
t(), con recogida de argumentos con arg(0), arg(1) o $_GET. Y os daréis cuenta
de que por doquier el código está acoplado a la base de datos, a las URLs, al
core, a otros módulos, [a sí
mismo](http://en.wikipedia.org/wiki/Law_of_Demeter)... veréis la cantidad de
funciones que devuelven HTML, que hacen muchas cosas a la vez y tienen muchos
distintos propósitos. Veréis plantillas con lógica de negocio y preprocess
omnipotentes de 350 líneas. Os daréis de bruces con la programación procedural
y desearéis poder [inyectar
dependencias](http://en.wikipedia.org/wiki/Dependency_injection), pero no
podréis.

Todos estos inconvenientes os obligarán a llevar la carga del testing a los
tests de integración, desesperadamente lentos y frágiles, y al final
terminaréis probando absolutamente todo desde la interfaz con clickLink(),
drupalGet() y drupalPost(). Y un día cambiaréis unas cuantas cosas de la
interfaz y os explotarán 7 test de 75 líneas cada uno y os estiraréis de los
pelos y os preguntaréis qué carajo se ha roto esta vez.

### De por qué y cómo sigo con Drupal

De todo esto me dí cuenta poco a poco, cuando después de leer a varios grandes
autores llegué a la conclusión de que eso del **TDD** era algo que valía la
pena intentar. Y así empezó mi historia de TDD con Drupal, que vino a ser muy
parecida a aquella historia sobre la paciencia y la fatiga, el elefante y la
hormiga. Y tras más de un año de colisiones y muchas ganas de abandonar
Drupal, llegué a la conclusión de que Drupal es un excelente gestor de
contenidos y vale la pena seguir usándolo en muchas de nuestras webs, pero si
quiero utilizarlo como framework va a ser con mis propias reglas; orientación
a objetos,
[MVC](http://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller) y
[BDD](http://en.wikipedia.org/wiki/Behavior_Driven_Development).

Los detalles de cómo apliqué todo esto [en la segunda
parte](http://www.carlescliment.com/blog/otra-manera-desarrollar-drupal-ii).

