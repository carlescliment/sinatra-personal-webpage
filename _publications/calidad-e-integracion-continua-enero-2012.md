---
title: Calidad e Integración Continua. Una introducción.
date: 2012-01-05
---

## Índice de contenidos

  1. Qué es la calidad
  2. Enemigos de la calidad
    1. La deuda técnica
    2. Las ventanas rotas
    3. El bus factor
    4. Bugs. Detección tardía
    5. Rigidez del software
  3. Desarrollo en cascada versus desarrollo ágil
    1. El desarrollo en cascada. La informática como ingeniería
    2. El desarrollo ágil. La informática como artesanía
  4. Testing y tipos de tests
    1. Tests unitarios
    2. Tests de integración
    3. Tests de regresión
    4. Tests de aceptación
  5. TDD
    1. Red - Green - Refactor
    2. Desarrollo guiado por especificación
    3. La importancia del diseño
    4. Pair programming con TDD. Ping-pong
  6. La integración continua
    1. El repositorio
    2. Principios para el desarrollador
    3. Tests continuos
    4. Staging
    5. Automatización de procesos
  7. El equipo de QA 
    1. QA y los desarrolladores
    2. QA y los usuarios
    3. ¿Es ágil QA?
  8. Buenas prácticas
    1. Code reviews
    2. Daily Stand-up Meetings y Retrospectivas
    3. Demos
    4. Regla del Boy Scout
    5. Pomodoro Technique
  9. Fundamentos de la calidad en el código 
    1. Coding standards
    2. Claridad
    3. Duplicidad
    4. Complejidad
    5. Acoplamiento
  10. Conclusiones
  11. Historial de revisiones

## Qué es la calidad

Existen muchas definiciones de calidad aplicadas al software. De entre las más
_tradicionales_ tenemos la ofrecida por el [Consortium for IT Software
Quality](http://en.wikipedia.org/wiki/Software_quality#Definition) o la
[ISO-9126](http://en.wikipedia.org/wiki/ISO_9126#Quality_Model). Cada una de
ellas destaca algunos atributos del software. Con el paso de los años, muchos
otros autores han ofrecido sus propias definiciones de la calidad.

Entonces, ¿qué es la calidad?. Todas las definiciones parecen converger, al
final, en los mismos puntos.

  * Conformidad con las especificaciones
  * Ausencia de errores... 
    * en la toma de requisitos
    * en la comunicación cliente-desarrollador
    * en la programación
    * en el procedimiento
    * en la documentación
    * ...
  * Satisfacción de las expectativas del cliente

Resulta muy difícil dar una definición de la calidad porque principalmente
**la calidad es una cuestión subjetiva**, y el epicentro de la calidad no está
en el código ni en las plataformas sobre las que se ejecuta, sino en las
personas y sus interacciones.

## Enemigos de la calidad

A continuación se explican algunos de los factores que pueden perjudicar
seriamente la calidad de un proyecto informático. Seguramente podamos escribir
y hablar sobre muchos otros más.

### La deuda técnica

La [deuda técnica](http://martinfowler.com/bliki/TechnicalDebt.html) es una
metáfora que se apoya en la deuda financiera. Del mismo modo en que muchos han
acumulado deuda para _invertir_ en un piso, desde los _stakeholders_ y a veces
desde los propios desarrolladores surgen presiones para hacer las cosas
deprisa, renunciando a soluciones más sólidas por otras más rápidas. A menudo
esta deuda viene justificada desde las esferas ejecutivas. Por ejemplo, es
posible que para una empresa sea crucial posicionarse en un nuevo nicho de
mercado, aunque su producto no cumpla con ciertos mínimos de calidad.

El problema de la deuda técnica es que, como la deuda financiera, repercute
con un interés que crece con el tiempo. Adecentar un código mal escrito cuesta
más que escribirlo bien desde el principio, y cuanto más tardemos en
adecentarlo más código se habrá levantado sobre él y menos lo conoceremos.

A diferencia de la deuda financiera, la deuda técnica no se puede cuantificar.
No hay manera de saber cuánto va a costar devolver esa deuda porque aún no
existe ningún modelo matemático que proporcione el coste preciso del
desarrollo del software. Como en la vida real, a menos deuda más seguridad. De
las empresas depende decidir si deben o no acudir a por un nuevo crédito.

### Las ventanas rotas

Otra de las metáforas que se han utilizado a menudo es la de las [ventanas
rotas](http://en.wikipedia.org/wiki/Broken_windows_theory). Se basa en una
teoría aplicada a la criminología que defiende que el vandalismo aumenta en
aquellos barrios donde no se restauran las fachadas de los edificios, donde no
hay inversión pública. El caos engendra el caos. Sin embargo, atajar los
problemas cuando aún son pequeños (tan pequeños como una ventana rota) es el
mejor remedio para evitar aumentos en la criminalidad.

En el código es fácil caer en la tentación de dejar una ventana rota. A veces
por pereza, por falta de tiempo, porque _"ya lo arreglo luego"_, aplicamos una
solución rápida y chapucera que queda siempre expuesta ante los compañeros.
Muy poca gente se siente a gusto con el desorden. Si trabajamos en un entorno
en el que el código es un galimatías lleno de incoherencias, ¿por qué vamos
nosotros a esforzarnos más que los demás arreglando los desperfectos que otros
han causado?. Si no trabaja todo el equipo por mantener el código en buenas
condiciones, el desánimo y la sensación de caos se extenderá alimentando
nuevas ventanas rotas.

### El Bus Factor

El [Bus Factor](http://en.wikipedia.org/wiki/Bus_factor) es el número de
personas de un equipo que deberían ser atropelladas por un autobús o
incapacitadas de cualquier otro modo para que fracasase un proyecto. Es una
medida de la concentración del conocimiento en el equipo.

Los programadores nos ponemos enfermos, sufrimos accidentes e incluso un día
llegamos a morir. A veces no hace falta nada de eso, nos cansamos de nuestro
trabajo y nos vamos. Normalmente, cuando nos vamos nos importa poco que
dejemos un proyecto _en calzoncillos_ por el Bus Factor.

Por eso es importante mantener un canal continuo de información entre los
miembros del equipo y establecer prácticas que fortalezcan la propiedad
colectiva del código y la propagación del conocimiento.

### Bugs. Detección tardía

Desgraciadamente, al menos por el momento, la ausencia completa de bugs en
cualquier sistema es una quimera. Los bugs van a convivir con nosotros
queramos o no, porque el proceso de desarrollo del software es tan complejo y
tiene tantos condicionantes que es imposible aislarlo de problemas. La
eficacia con la que prevengamos los bugs y la rapidez con la que actuemos
contra ellos serán críticas para el éxito de cualquier proyecto.

![Incremento del coste en la detección tardía de los
bugs](/images/calidad_01_2012/bugs_deteccion.png)

En la figura de arriba se observa el impacto de un bug según el momento en el
que es descubierto. Un bug en la especificación será muy fácil de corregir si
se detecta durante el análisis. Una vez nos pongamos a programar, el bug será
más costoso porque implicará volver a definir la especificación y afectará a
partes del sistema ya programadas. Si no se detecta durante la integración del
software, el bug podrá afectar al código desarrollado por otros compañeros,
creciendo en magnitud. Un bug descubierto tras el despliegue, sobre todo si
nació en la especificación, puede suponer un completo desastre.

Para una detección rápida de los bugs es necesario, de nuevo, fortalecer la
comunicación entre desarrollador y cliente, y entre desarrollador y
desarrollador. El testing, la práctica de TDD, el pair programming, las code
reviews, las demos o el departamento de QA son, entre otros, actores que
pueden ayudarnos a detectar los bugs lo antes posible.

### Rigidez del software

A los desarrolladores no nos gusta que los clientes o personas no técnicas nos
impongan soluciones técnicas. No queremos que nos digan si debemos usar un
lenguaje u otro, o si debemos usar Oracle en lugar de MySQL. Porque las
decisiones técnicas forman parte de nuestro trabajo.

Del mismo modo, nuestras soluciones técnicas no pueden condicionar o
constreñir la lógica de negocio del cliente. He participado en algunas
reuniones con conversaciones como esta:

> **Desarrollador:** Bien, Manolo, hemos llegado a una solución optimísima
para tu web de resultados de partidos de baloncesto. Hemos implementado un
fluffer que utiliza el algoritmo de flatgury para abrir un flurry con el api
de baloncestos.com. ¡Además lo hemos hecho en tiempo record!. Esto nos
permitirá ir un par de días por delante de lo previsto.

> **Cliente:** (no ha entendido nada) ¡Pues eso es estupendo! ¿Entonces vamos a tener lista esa funcionalidad para la demo del jueves?

> **Desarrollador:** ¡Claro! Aquí hacemos las cosas bien (ahora ponemos cara muy seria). Sin embargo, tienes que prometerme una cosa..

> **Cliente:** (se remueve en su silla, asustado) Uh, ¿el qué?

> **Desarrollador:** Nuestra conexión con baloncestos.com a través del flurry del fluffer utiliza una librería muy específica para el tratamiento de canastas. Tienes que prometerme que nunca vas a mostrar resultados de fútbol, rugby ni ningún otro deporte que no utilice canastas. Si no, ¡tendremos que hacer la aplicación de nuevo casi desde cero!

En una conversación como la descrita pueden ocurrir dos cosas. O bien el
cliente se niega a aceptar esa restricción, o bien se encoge de hombros y
acepta. Nunca debemos poner al cliente ante este dilema, porque nuestra
obligación profesional es ofrecer _soluciones_ y no _restricciones_.

## Desarrollo en cascada versus desarrollo ágil

El desarrollo del software es un campo del conocimiento recién nacido. En la
segunda mitad del siglo XX se hicieron grandes esfuerzos para establecer
procedimientos que permitiesen abordar los proyectos informáticos con
garantías. Y para ello, trataron de emular a otras disciplinas del
conocimiento que ya llevaban una larga andadura. Trataron de enfocar el
desarrollo del software como una ingeniería. Es lo que llamamos desarrollo en
cascada.

El tiempo sin embargo ha ido demostrando que estos procesos no son tan
efectivos como se creía. Porque las variables que inciden en el desarrollo del
software son más difícilmente mesurables que las que lo hacen en las
ingenierías tradicionales. O, al menos, la informática no ha avanzado lo
suficiente como para medirlas. Así, existen modelos matemáticos para comprobar
la resistencia del viento, el número de olas que resiste una plataforma
petrolífera, la erosión provocada por el cauce de un río o el grosor apropiado
para sostener determinado puente con cables de acero.

El software no ha llegado a esa madurez y se mueve en un entorno de mucha
mayor incertidumbre. No podemos saber qué tecnologías surgirán en los próximos
meses que podrán beneficiar o dejarán obsoleto nuestro trabajo. No podemos
predecir cambios en las necesidades de los clientes, ni en las percepciones de
los usuarios. ¿Quién iba a imaginar hace diez años el impacto causado por las
redes sociales?.

Un puente se construye para que cumpla su función, que generalmente será
siempre la misma en toda su vida útil. Una aplicación, en cambio, debe
adaptarse constantemente a los cambios en el entorno.

### El desarrollo en cascada. La informática como ingeniería

![Metodologías tradicionales. Diagrama de
Gantt](/images/calidad_01_2012/gant-chart.jpg)

El desarrollo tradicional o en cascada trata de eliminar la incertidumbre en
las primeras etapas del desarrollo del software. Estas etapas son lineales y
están muy delimitadas. Para eliminar la incertidumbre, en la fase de análisis
y toma de requisitos, los analistas se reunen con el cliente con el objetivo
de extraer todas sus necesidades con el máximo detalle. Al cliente se le hace
firmar un documento y estos requisitos son después modelados por los
arquitectos del software a través de distintos diagramas UML como diagramas de
casos de uso, de clases, de interacción, de entidad-relación, etc.

Todo este proceso de modelado se lleva a cabo en la fase de Diseño, y su
objetivo es generar una documentación suficiente para que los programadores
escriban el código necesario para implementar el sistema. El proceso de
codificación se considera casi rutinario, ya que se trata de traducir lo que
los arquitectos han modelado a un lenguaje que entienda la máquina. Incluso se
han hecho esfuerzos para traducir automáticamente los modelos a lenguajes de
programación a través de los generadores de código y enviar al paro a miles de
programadores.

Finalmente se contrata a un ejército de testers para que se pasen días
probando la aplicación. En algunos casos, incluso se programan tests de
regresión o de integración. Más le vale al equipo que todo funcione a la
primera porque a estas alturas el cliente ya está nervioso por tener la
aplicación que lleva meses (o años) esperando.

Cuando los testers dan el visto bueno, por fin, se entrega la aplicación y se
despliega en el entorno del cliente. Y entonces puede ocurrir que la
aplicación ya no sirva. Que el los requisitos de negocio que se documentaron
en las primeras fases hayan cambiado, o que estos mismos requisitos hayan sido
malinterpretados. Ha ocurrido esto tantas veces que los desarrolladores nos
hemos ganado una dudosa reputación.

El desarrollo en cascada tiene varios puntos débiles:

  * No podemos disipar la incertidumbre al principio del proyecto, porque es cuando más sometidos estamos a esa incertidumbre.
  * No podemos excluir al cliente de la mayoría del ciclo de desarrollo, porque necesitamos una comunicación permanente con él para asegurarnos de que lo que estamos haciendo es lo que él necesita
  * No podemos comprometernos a una fecha de entrega con garantías, porque con el modelo en cascada cualquier retraso en una de las tareas repercutirá en las tareas posteriores.
  * No podemos separar el modelado del sistema y su implementación, porque a menudo los lenguajes de programación o las máquinas sobre las que trabajan imponen sus propias reglas. Es responsabilidad del desarrollador utilizar soluciones que permitan, en estos casos, satisfacer el requisito del cliente. Es decir, no podemos despreciar la importancia de la programación.

### El desarrollo ágil. La informática como artesanía

![Metodologías ágiles, proceso de
desarrollo.](/images/calidad_01_2012/agile_process.jpg)

En el año 2001, 17 de los desarrolladores de software de referencia se
reunieron para proponer alternativas a las metodologías tradicionales de
desarrollo y enunciaron el [manifiesto ágil](http://agilemanifesto.org/). En
este manifiesto afirmaban que daban más valor a:

  * **Individuos e interacciones** sobre procesos y herramientas
  * **Software funcionando** sobre documentación extensiva
  * **Colaboración con el cliente** sobre negociación contractual
  * **Respuesta ante el cambio** sobre seguir un plan

Con estas bases, en la última década han surgido metodologías como
[Scrum](http://en.wikipedia.org/wiki/Scrum_%28development%29) o
[Kanban](http://en.wikipedia.org/wiki/Kanban_%28development%29) que tienen
varios puntos en común.

  * Planificación iterativa. En cada iteración se decide qué funcionalidades se van a implementar.
  * Comunicación y propiedad colectiva. Todo el equipo sabe en qué están trabajando sus compañeros. Se busca el compromiso del equipo y compartir responsabilidades.
  * El código se revisa y prueba constantemente. Se busca la excelencia y una producción más artesanal.
  * En cada iteración se entrega valor al cliente. No hay una única entrega al final. El cliente dispone de valor añadido de una forma incremental y continua, y puede modificar los requisitos o añadir nuevos.
  * Los equipos son multidisciplinares. No hay especialistas. No hay arquitectos. Todos comparten las mismas responsabilidades, aunque se valora la experiencia y el conocimiento de los individuos.

El desarrollo ágil busca estrechar los lazos entre el cliente y el
desarrollador. Ya no son vistos como actores con intereses opuestos, sino como
colaboradores. El cliente se compromete a mantener un contacto fluído con el
equipo de desarrollo y el equipo de desarrollo a dar lo mejor de sí mismos en
el proyecto.

## Testing y tipos de tests

Hasta hace no mucho, el control de la calidad en el software se llevaba a cabo
mediante _testers_, personal encargado de probar y evaluar todos los rincones
de la aplicación. Normalmente con la ayuda de una _checklist_, estos
incansables trabajadores repetían una y otra vez las mismas pruebas cada vez
que se liberaba una versión, para asegurarse de que nada se había roto por el
camino. Aunque los testers siguen siendo necesarios en muchos casos, con el
tiempo la industria ha aprendido que los tests manuales no son suficientes.
Por ello se han ideado frameworks para todos los lenguajes y plataformas que
permiten automatizar estos tests sobre las aplicaciones.

Los test automáticos deben seguir unos principios, que se definen en el
acrónimo **FIRST**:

  * **F**ast - Deben ser rápidos. Cuando son lentos, no queremos ejecutarlos con frecuencia. Es bueno medir los test porque permiten identificar secciones muy lentas del código.
  * **I**ndependent - Un test no debería depender de otro, ni preparar las condiciones del siguiente test.
  * **R**epeatable - Deben poder ejecutarse una y otra vez si cambiar el resultado obtenido bajo el mismo contexto.
  * **S**elf Validating - Los test deben devolver información sobre si han tenido éxito o no.
  * **T**imely - Los test deben escribirse en el momento apropiado (ANTES que el código). 

Los tests, según quién los ejecuta y en qué contexto, pueden clasificarse en
varios tipos. Aquí se resumen los principales:

  * Tests unitarios
  * Tests de integración
  * Tests de regresión
  * Tests de aceptación

### Tests unitarios

Los tests unitarios prueban funcionalidades en fragmentos muy pequeños del
código. Normalmente un test unitario prueba un método público de una clase de
forma aislada, sin interacción con la base de datos, sin acceder a ficheros y
sin interactuar con otros componentes del sistema.

El test unitario es el test a más _bajo nivel_, y por su granularidad es el
test más robusto. Es el utilizado en la programación a objetos con TDD.

### Tests de integración

Los tests de integración comprueban el trabajo en conjunto de varios
componentes del sistema. Por ejemplo, un test de integración puede acceder a
una interfaz con un formulario para asegurarse de que los datos introducidos
en él son almacenados en la base de datos.

Para que los tests de integración sean repetibles, a menudo se utilizan
estrategias como
[sandboxes](http://en.wikipedia.org/wiki/Sandbox_%28software_development%29)
que permiten generar y destruir datos en cada test.

Los tests de integración son más vulnerables que los unitarios porque dependen
de varios componentes. Un cambio en cualquier componente puede hacer que falle
el test. Además son más lentos porque tienen que _despertar_ más recursos, por
lo que su práctica constante en el proceso de desarrollo es más incómoda. Por
ello es recomendable minimizar los tests de integración probando con tests
unitarios todo lo que podamos.

La barrera que separa unos y otros puede ser, en algunos casos, difícil de
ver, y es posible encontrar tests de integración junto a tests unitarios.

### Tests de regresión

Los tests de regresión prueban el sistema al completo y se aseguran de que las
funcionalidades anteriores han sido preservadas. Normalmente se lanzan antes
de desplegar una nueva versión utilizando herramientas como
[Selenium](http://seleniumhq.org/) que acceden a las interfaces de la
aplicación y repiten mecánicamente acciones programadas con scripts.

Estos tests de altísimo nivel son los más frágiles porque están fuertemente
acoplados con la interfaz. Un mínimo cambio en la interfaz puede significar
que la herramienta de testing ya no sea capaz de interactuar con la
aplicación, y el tests ofrezca un resultado negativo. Por ello, los tests de
regresión son los que más mantenimiento necesitan y los que más _ligeros_
deben mantenerse, probando solo lo necesario y delegando en tests de más bajo
nivel.

### Tests de aceptación

Los tests de aceptación son los tests que el cliente escribe (con la ayuda de
un analista) y que definen con precisión una funcionalidad. En el desarrollo
ágil, normalmente detallan las reglas de validación para una [historia de
usuario](http://en.wikipedia.org/wiki/User_story). Los tests de aceptación
deben estar escritos en un lenguage descriptivo y no formal, comprensible para
perfiles no técnicos.

Existen herramientas que permiten automatizar las pruebas de aceptación. Por
ejemplo, [Fitnesse](http://www.fitnesse.org/) permite interpretar los tests de
aceptación en una página HTML y ejecutar esos tests sobre la aplicación para
comprobar los resultados.

![Captura de pantalla de
Fitnesse](/images/calidad_01_2012/fitnesse.png)

## TDD

De entre los puntos a tratar en este artículo, este es el que afronto con más
prudencia y reservas. Tanto es así que he estado tentado de pasarlo por alto.
Pero hablar de calidad sin explicar TDD es como describir el mar sin hablar de
las olas. Si me cuesta tanto tratar este tema es porque TDD es, probablemente,
la práctica más difícil de todas las que explico en este texto y, a la vez, la
más determinante. Yo empecé a interesarme seriamente por la calidad del
software hace apenas un año y recién empiezo a dar los primeros pasos.

Si queréis profundizar en el asunto (y si habéis llegado hasta aquí seguro que
lo haréis) podéis empezar por el estupendo libro de [Carlos
Ble](http://www.carlosble.com/), [Dirigido por
tests](p://www.dirigidoportests.com/el-libro). Es un libro excelente y,
además, gratuíto. También os recomiendo su [charla sobre
TDD](http://vimeo.com/9932447), de la cual bebe mucho este artículo.

### Red - Green - Refactor

El algoritmo es sencillo. Cuando vayamos a implementar un nuevo módulo o clase
crearemos dos archivos. En uno de ellos estará la implementación o código de
producción y en el otro los tests. Tomaremos uno de los requisitos del cliente
y lo desmenuzaremos hasta el nivel mínimo, una microfuncionalidad que podamos
expresar en una sola frase.

Antes de escribir una sola línea de código de producción implementaremos la
prueba que verifique que esa funcionalidad se cumple. Puede ser algo tan
sencillo como verificar el resultado de una suma, separar las palabras de una
cadena con comas o añadir un elemento dado a un array. Una vez escrita la
prueba intentaremos ejecutarla. Fallará, claro, dado que aún no hemos
implementado nada, pero es una buena práctica intentarlo de todos modos porque
en proyectos más grandes es posible que, sin darnos cuenta, estemos apunto de
replicar funcionalidades ya implementadas. Estamos en fase Red, y se le da
este nombre porque las herramientas de testing suelen mostrar con este color
los tests fallidos.

Una vez implementada la prueba pasaremos a implementar el código mínimo que la
haga pasar. Es importante que no escribamos nada más que el código necesario
para que pase. A medida que vayamos añadiendo tests el código se irá
levantando por sí solo respetando el principio
[YAGNI](http://en.wikipedia.org/wiki/You_ain%27t_gonna_need_it). Cuando
hayamos implementado la lógica mínima que haga pasar el test estaremos en la
fase Green.

El último paso en la receta de la TDD es eliminar duplicidades y refactorizar.
El refactoring continuo garantizará que respetamos el respeto
[DRY](http://en.wikipedia.org/wiki/Don%27t_repeat_yourself) y que mantenemos
nuestro código en condiciones óptimas.

Este proceso se repite hasta que el sistema al completo ha sido terminado.

### Desarrollo guiado por especificación

Como hemos visto, la especificación y no el modelado del sistema es el centro
del desarrollo. Siguiendo estas prácticas garantizamos que la aplicación
cumple completamente con las especificaciones dadas. También evitamos invertir
recursos en código que nunca vamos a utilizar. Se programa exculsivamente
aquello que se nos ha pedido y nada más.

Con el desarrollo guiado por especificación, ya no estamos implementando
clases, ni interfaces, ni funciones. Estamos añadiendo progresivamente
funcionalidades que el cliente/usuario va a poder utilizar tan pronto como
terminemos y entregemos. Las sinergias de TDD con el desarrollo iterativo son
espectaculares.

### La importancia del diseño

Una de las ventajas de aplicar TDD es que el diseño surge de manera natural a
medida que se desarrolla el código. Para ello es necesario ayudarse de
patrones de programación y aplicar técnicas como la inyección de dependencias.
La consecuencia inevitable de TDD es que el diseño resultante de la aplicación
es más limpio y está menos acoplado que con el desarrollo convencional.

### Pair programming con TDD. Ping-pong

[Ping pong](http://en.wikipedia.org/wiki/Pair_programming#Ping_pong_pair_progr
amming) combina TDD con la [programación en
parejas](http://en.wikipedia.org/wiki/Pair_programming), y es una excelenta
manera de aprender, de compartir conocimientos, de fortalecer al equipo y de
hacer la jornada de trabajo más divertida. Uno programa el test, otro programa
el código y refactoriza. Después intercambian los roles. Aunque es posible
practicar TDD sin pair programming y pair programming sin TDD, la realizar
estas dos prácticas de manera conjunta es muy recomendable.

## La integración continua

Los desarrolladores no trabajan solos sino en equipo, al menos en la mayoría
de los casos, y cuando un desarrollador aporta el código que ha desarrollado
al flujo común de trabajo pueden surgir problemas de integración. Por ejemplo,
dos desarrolladores trabajando sobre el mismo código pueden producir
conflictos en el repositorio. También pueden, sin quererlo, provocar una
inestabilidad en el código de un tercero que dependía de una clase modificada
por ellos.

La integración continua es un conjunto de _buenas prácticas_ que trata de
combatir los problemas de integración integrando más a menudo.

### El repositorio

El repositorio de control de versiones permite mantener un historial
actualizado y compartir código con comodidad. Pero al contrario de lo que
algunos desarrolladores piensan, el repositorio no es un _vertedero para
compartir código_. Debemos tratar el repositorio como si del código de
producción se tratara, manteniéndolo en todo momento limpio y estable.

### Principios para el desarrollador

En el capítulo segundo del libro [Continuous Integration: Improving Software
Quality and Reducing Risk](http://my.safaribooksonline.com/book/software-
engineering-and-development/software-testing/9780321336385), sus autores
enumeran siete buenas prácticas para los desarrolladores. Me he permitido
reducirlas a las 5 que considero más importantes.

  * **Contribuye a menudo.** Si contribuyas tu código a menudo, en pequeñas porciones, reducirás el riesgo de colisiones con tus compañeros. Además, el equipo podrá utilizar las funcionalidades que hayas desarrollado tan pronto como las hayas contribuído.
  * **No contribuyas código roto.** Si contribuyes código roto estás poniendo en riesgo el trabajo de tus compañeros. Ellos utilizarán tu código suponiendo que es estable y, posiblemente, levanten código sobre él.
  * **Soluciona los builds rotos inmediatamente.** Por la razón comentada en el anterior punto, solucionar los problemas en el código del repositorio debe convertirse en la primera prioridad del equipo.
  * **Escribe tests automáticos.** La única manera de asegurar que un código es estable es cubriéndolo con tests. Un código sin tests se considera código inestable, por lo que todo commit al repositorio debería ir acompañado de sus tests correspondientes. Esto no será problemático si desarrollamos con TDD.
  * **Todos los tests deben pasar.** Aunque parezca algo elemental, algunas empresas permitían un margen de fallos en sus tests automáticos (por ejemplo, un 2%). Por todo lo comentado hasta ahora, si nos planteamos empezar a aplicar integración continua todos los tests automáticos deben pasar en todo momento.

### Tests continuos

Los desarrolladores deben ejecutar tests a medida que van desarrollando
código. Normalmente es responsabilidad del desarrollador ejecutar
constantemente los tests unitarios del código que está modificando. Además de
estos tests y como hemos visto, existen otros tests de mayor nivel que
aseguran la estabilidad del sistema. Como estos otros tests son bastante más
lentos y ejecutar toda la batería de tests del proyecto podría resultar
verdaderamente engorroso, la ejecución de los tests del build completo se deja
en manos de servidores de integración continua.

Existen varios sistemas de integración continua disponibles en el mercado,
como [Jenkins]() o [CruiseControl](). Estas aplicaciones pueden instalarse en
máquinas dedicadas al control del código. Cuando un desarrollador contribuye
código, el servidor de integración continua se pone en marcha para levantar el
build y ejecutar el set de tests. En función de la configuración del sistema,
el servidor puede rechazar el commit o enviar un aviso al equipo. Cuando los
tests son demasiado pesados como para ser ejecutados en cada commit pueden
seguirse otras estrategias como ejecutar los tests de manera periódica.

![Jenkins. Captura de
pantalla](/images/calidad_01_2012/jenkins.png)

Hay muchas maneras de avisar al equipo de un test fallido, desde las [lámparas
de lava](http://blog.coryfoy.com/2008/10/build-status-lamp-with-ruby-and-
teamcity/), los e-mails e incluso los
[lanzamisiles](http://www.youtube.com/watch?v=1EGk2rvZe8A). Que cada equipo
elija la que considere más apropiada.

### Staging

![Separación de
entornos](/images/calidad_01_2012/staging.png)

El staging consiste en la separación de entornos de trabajo. Permite aislar el
entorno de desarrollo del de pruebas, y éste del de producción. Lo habitual en
la mayoría de empresas es distinguir entre cuatro entornos: Local, Desarrollo,
Pre-producción y Producción.

El **entorno de desarrollo** es aquel en el que el desarrollador trabaja
diariamente. El desarrollador hace un checkout del repositorio para trabajar
en su máquina local y evitar conflictos con los desarrolladores. Si la
aplicación necesita una base de datos, el desarrollador tendrá que
configurarse un clon de la misma en su propia máquina. Es recomendable
actualizar la copia de la base de datos a menudo.

El **entorno de integración** es el que utilizan todos los desarrolladores
para integrar y probar el software en su conjunto. Como hemos comentado con
anterioridad, al tratarse del espacio de trabajo común debe tenerse especial
cuidado con mantenerlo limpio y estable.

El **entorno de preproducción** es un entorno aislado que se utiliza antes de
los despliegues para realizar las pruebas finales. También puede servir para
llevar a cabo las demos con cliente o testing con usuarios reales (beta-
testing). Es importante que las características de configuración de este
entorno, tanto en hardware como en software, sean tan parecidas como sea
posible a las del entorno de producción. De este modo evitaremos problemas
provocados por diferencias de versiones de software, hardwares incompatibles y
problemas similares.

El **entorno de producción**, finalmente, es donde los clientes o usuarios dan
uso a la aplicación. Puede ser un servidor web en el caso de sites online u
ordenadores personales en aplicaciones comerciales.

Utilizar estos entornos de un modo ordenado nos permitirá desplegar siempre
código estable y estar listos en todo momento para poder responder a
necesidades del cliente. Además de entornos separados necesitaremos la ayuda
del repositorio en forma de
[branches](http://en.wikipedia.org/wiki/Branching_%28software%29).

Lo recomendable es que exista una rama principal, llamada _trunk_, que es la
que utilizan a diario los desarrolladores para contribuir código.
Paralelamente existe otra rama, denominada _stable_ que es una réplica exacta
del código de producción. En cada ciclo de desarrollo, una vez las nuevas
funcionalidades han sido validadas y se han pasado con éxito los distintos
tests (regresión, integración, unitarios...), la rama _trunk_ se copia en la
rama _stable_ y se despliega el código a los clientes.

Mantener una rama stable ofrece una especie de _nevera_ de código que no ha
sido modificado durante el desarrollo. Imagina que tu equipo despliega código
cada dos semanas. En el día quinto de la iteración, el cliente descubre un bug
serio que necesita intervención inmediata. No podemos llevar a cabo el
procedimiento habitual _trunk -> stable -> despliegue_ porque en _trunk_
tenemos funcionalidades incompletas o código que sencillamente no queremos
desplegar. Por fortuna, podemos realizar las modificaciones oportunas
directamente en _stable_ y desplegarlas al cliente, manteniendo todo el código
desarrollado en estos cinco días en "cuarentena" dentro de _trunk_. Por
supuesto antes de desplegar tendremos que pasar todos los tests automáticos y
aplicar el parche en la rama _trunk_ para que la solución no se pierda en el
próximo despliegue.

### Automatización de procesos

La integración continua consiste en realizar los procesos cotidianos (como
contribuir código, pasar tests o desplegar código) de forma constante, y para
ello es recomendable introducir automatismos. La regla de oro es _"si lo vas a
hacer dos veces, automatízalo"_. Seguramente termines haciéndolo muchas más.
Así, los sistemas de integración continua no solo sirven para ejecutar tests y
avisar a los desarrolladores en el caso de que el build se haya roto. También
sirven para ejecutar todo tipo de scripts, como movimientos en ramas del
repositorio, descargas de bases de datos o ejecución de analizadores de
código. Don't Repeat Yourself.

## El equipo de QA

Implantar metodologías, protocolos, prácticas y herramientas para la mejora de
la calidad en equipos que parten de cero es una tarea muy ardua. Está sometida
a dificultades de tipo técnico, de tipo organizativo y de tipo psicológico.
Para romper estas barreras y abrise camino en un entorno donde hay falta de
formación, de disciplina o de motivación, algunas empresas crean equipos
especializados en la calidad.

Los objetivos principales de un equipo de QA son:

  * Evaluar la calidad en el equipo y detectar los puntos de mejora.
  * Ayudar al equipo a adoptar metodologías y hábitos que mejoren su trabajo
  * Estudiar constantemente nuevas maneras de mejorar la calidad.
  * Tomar el pulso a la satisfacción de clientes y usuarios, accionando constantemente medidas para aumentarla.

### QA y los desarrolladores

La relación de QA con algunos miembros del equipo puede tensarse si estos
consideran que se está cuestionando su buen hacer como profesionales. Es
fundamental trabajar en consensos sobre qué normas y límites se establecen
sobre la calidad del código y los procesos. En los casos en los que una
directiva de calidad se considere innegociable, siempre debe aplicarse con
argumentos sólidos que la respalden. Las normas, por lo general, no son buenas
si no traen beneficios.

Cuando un desarrollador envía su tarea a QA, lo que quiere es olvidarse de la
tarea en cuestión y concentrarse en la siguiente. Si constantemente se le
están devolviendo tareas porque no pasan los controles de calidad, es
comprensible que acabe acumulando sentimientos negativos hacia un equipo al
que considera un oponente.

Es importante que el equipo entienda que QA es un colaborador que les va a
ayudar a mejorar como profesionales. El tacto o talante en QA es clave, y la
incorrecta gestión de la psicología del equipo es el principal problema al que
nos enfrentamos los profesionales de perfil técnico que nos vemos inmersos en
este tipo de funciones.

Deberemos trabajar especialmente nuestra relación con los desarrolladores más
veteranos. Según mi limitada experiencia son los que ofrencen mayores
resistencias a la hora de afrontar cambios en su forma de trabajar.

### QA y los usuarios

Para saber si nuestras aplicaciones cumplen con los objetivos para los que
fueron diseñadas es necesario establecer canales de comunicación con los
usuarios. Pueden ser estudios analíticos de uso de la aplicación, encuestas de
satisfacción o cualquier otro método que sirva para recoger feedback de los
desarrollos que se van liberando.

En mi opinión, la mejor manera de saber cómo experimenta un usuario la
aplicación es sentándose junto a él y observar. A menudo, el usuario te
sorprende mostrándote formas de utilizar la aplicación que no habías
imaginado.

### ¿Es ágil QA?

Bajo una perspectiva ágil, cuanto más fuerte es QA más débil es el equipo. Uno
de los objetivos de QA es supervisar el trabajo de los desarrolladores, y
supervisar implica desconfiar. Pero ocurre que no se consigue un equipo
virtuoso y excelente en seis días.

QA es especialmente necesario en equipos desorganizados o que aún no han
tenido un contacto suficiente con las metodologías ágiles y los principios de
la calidad. En estos entornos es necesario formar una vanguardia centrada al
100% en avanzar en la calidad y propagar el conocimiento al resto del equipo.
A medida que el equipo vaya aprendiendo las nuevas formas de trabajar, el
equipo de QA verá reducida su carga de trabajo. Idealmente llegará un momento
en el que QA sea innecesario porque todas sus responsabilidades serán asumidas
por el equipo. Os deseo buena suerte y espero que ese día llegue pronto para
vuestros equipos.

## Buenas prácticas

A estas alturas ya hemos aprendido un montón de cosas para mejorar la calidad
de nuestro equipo. Hagamos un repaso a lo visto hasta ahora.

  * Intensificar nuestra relación con el cliente, haciéndolo partícipe del proceso de desarrollo como un colaborador más, y ayudándole a saber lo que en realidad necesita. Ayudémosle también a explicárnoslo a través de los tests de aceptación.
  * No nos carguemos de deuda técnica. Y si no hay más remedio, deshagámonos de ella tan pronto como sea posible.
  * Ojo con las ventanas rotas. Buscamos la excelencia. Somos artesanos.
  * Seamos una hidra de muchas cabezas reduciendo el bus factor.
  * No dejemos que nuestras soluciones técnicas afecten negativamente al cliente.
  * Apliquemos el desarrollo iterativo y las metodologías ágiles para darle constantemente valor añadido al cliente y adaptarnos fácilmente a nuevas necesidades.
  * Nuestro código debe estar a prueba de balas, aprendamos a hacer TDD.
  * Dividamos los grandes problemas en problemas pequeños aplicando la integración continua.
  * El camino hacia la excelencia es duro y está lleno de impedimentos. Un [equipo de QA](qa) puede ayudar a avanzar en él con paso firme.

¿Podemos hacer algo más? ¡Claro! Podríamos estar hablando horas y horas sobre
calidad del software. Aquí van unas poquitas buenas prácticas que añadir a
nuestro recetario.

### Code reviews

El pair programming es una excelente manera de eliminar el bus factor y
extender el conocimiento en el equipo. Los más veteranos trabajan codo con
codo con los más nuevos para compartir todo su conocimiento. Pero a veces la
práctica del pair programming se hace más complicada, por ejemplo en equipos
distribuídos. No todos los desarrolladores encajan con esta manera de trabajar
y algunas empresas tienen sus reservas para practicar pair programming de
manera sistemática.

Una buena alternativa (o complemento) al pair programming son las code
reviews. En las code reviews, un miembro del equipo o varios inspeccionan el
código realizado por otro compañero y piensan cómo podrían mejorarlo.

En las code reviews entran muchos factores psicológicos. El desarrollador que
está siendo revisado debe tener la mente abierta a las críticas. Los
desarrolladores somos por lo general gente con mucho orgullo y hay quien se
toma bastante mal que le corrijan el código. Abramos la mente y aprendamos de
las críticas, porque con la mente cerrada no se puede aprender.

Por otra parte, cuando revisamos el código de un compañero debemos tener en
cuenta que no tratamos con máquinas, sino con personas. Si estamos revisando
el código a través de una herramienta como
[Crucible](http://www.atlassian.com/software/crucible/overview) o
[CodeStriker](http://ostatic.com/codestriker), debemos ser sensibles con
nuestros comentarios sobre el código. Hay muchas maneras de decir que algo es
mejorable, y las formas cuentan.

La inspección del código es una actividad de la que se aprende muchísimo.
Además de ver otras maneras de resolver problemas podemos aportar nuestros
consejos. Por ello hay que tomárselo muy en serio y no activar el _modo
scanner_. El modo scanner se activa cuando en realidad no te apetece revisar
el código, y se manifiesta en un abuso del scroll en la rueda del ratón.
Cuando revisas en modo scanner te fijas en tres o cuatro cosas, funciones muy
largas, variables muy cortas, falta documentación... y las repites sin parar
en cada método o función. Si te descubres haciendo esto, para, tómate un
descanso o déjalo para otro día en el que estés más concentrado.

Las code reviews en parejas son excelentes para entrenar a los recién
llegados. Siéntate con el nuevo compañero y ponte a revisar código de algún
veterano. Explícale por qué hace esto y lo otro, y dale tu visión de cómo se
podrían mejorar algunos puntos. Te sorprenderá lo rápido que aprende y él se
sentirá cada día más integrado y cómodo.

Hay que tener en cuenta que revisar código exige mucho de nosotros, y por ello
debemos realizar esta práctica en dosis reducidas. Por mi experiencia, no
recomiendo code reviews de más de media hora. Son tan fructíferas como
agotadoras.

### Daily Stand-up Meetings y Retrospectivas

Tanto desde las metodologías ágiles como desde la integración continua se
defiende la mejora del equipo a través del feedback continuo. Si introduces
Kanban o Scrum en tu equipo de trabajo (y espero que lo hagas) empezarás a
realizar daily stand-up meetings (o daily meetings) y reuniones retrospectivas
de manera habitual.

Los [daily meetings](http://www.mountaingoatsoftware.com/scrum/daily-scrum)
son una breve reunión diaria en la que todo el equipo cuenta en qué ha estado
trabajando desde la reunión anterior y qué va a hacer a continuación. Es una
reunión por y para el equipo cuyo objetivo es intensificar las interacciones
entre sus miembros y mantener un canal constante de información. En el enlace
con el que empieza este párrafo encontraréis más información.

Las [retrospectivas](http://www.agilegamedevelopment.com/2008/06/when-we-talk-
about-agile-we-use-phrase.html) son reuniones que se llevan a cabo durante el
cambio de una iteración a la siguiente. El equipo se reúne para evaluar qué ha
ido bien y qué ha ido mal en la última iteración, y se plantea medidas para
mejorar en las iteraciones siguientes. Las retrospectivas, así como los daily
meetings, son reuniones obligatorias. Todo el equipo puede y debe participar.

Es importante que las retrospectivas sean _time-boxed_. La duración de la
reunión la decidirá el equipo. Estas reuniones tienen un objetivo claro;
averiguar cómo podemos mejorar nuestra manera de trabajar. A lo largo de un
año de retrospectivas he encontrado los siguientes problemas:

  * Algunos asistentes se limitan a escuchar.
  * Se crean debates técnicos en círculos cerrados que aburren a los demás.
  * Se repiten los mismos problemas de una retrospectiva a otra.

En realidad no es ningún problema que un miembro del equipo se limite a
escuchar durante las retrospectivas. Hay gente más y menos tímida y gente más
o menos imaginativa. En Scrum, el que posee el rol de Scrum Master es el
encargado de animar (y no presionar) a estos compañeros a que aporten su punto
de vista en la reunión.

Al principio de la reunión debe dejarse claro cuál es el objetivo de la misma.
Será necesario repetirlo tantas veces como sea necesario hasta que todos los
miembros del equipo lo entiendan. Deben atajarse los debates de carácter
técnico y posponerse para otras reuniones. El grupo debe estar centrado en una
sola idea; cómo mejorar como equipo.

Lo ideal es que la reunión retrospectiva termine con un pacto entre los
miembros del equipo. Una vez identificados los problemas, deben proponerse
medidas muy concretas para atajarlos, y el equipo debe comprometerse con
ellas. Si el problema persiste en la siguiente iteración, conviene preguntarse
si las medidas se han aplicado bien o si no eran efectivas. En este segundo
caso buscaremos medidas nuevas. Es una buena idea, de todas maneras, repasar
los compromisos adquiridos en la retrospectiva anterior.

### Demos

Las demos consisten en enseñar al cliente (o al responsable del proyecto en su
lugar) qué es lo que se ha estado desarrollando en la iteración. Es
recomendable que esta demostración no sea conducida, es decir, que al menos en
parte sea el propio cliente el que explore la aplicación ratón en mano.
Deberían realizarse sistemáticamente en todas las iteraciones. Si no hay
ninguna interfaz de usuario que mostrar, entonces se muestran diagramas o se
explica de viva voz qué es lo que se ha implementado y para qué se va a
utilizar. Es conveniente utilizar un lenguaje apropiado a la audiencia,
evitando tecnicismos o conceptos puramente informáticos. Encuentro en las
demos las siguientes ventajas:

Con las demos, el equipo adquiere un compromiso mayor con los objetivos
definidos en la iteración. A nadie le gusta hacer el ridículo delante de un
proyector con varias personas mirando. Esta presión es positiva, y provoca que
los desarrolladores seamos más cuidadosos con nuestro trabajo.

Otra de las ventajas es que nosotros como desarrolladores pensamos de un modo
diferente a los usuarios. Cuando entregas el ratón al cliente para que
"juegue" con la aplicación, él la usará de modos que a los desarrolladores
probablemente nunca se nos hubieran ocurrido. Mientras desarrollas, sin darte
cuenta, tú mismo te marcas unos márgenes mentales de los que a veces es
difícil escapar. El cliente, sin embargo, llega con la mente totalmente en
blanco y actúa como un excelente tester.

Aunque es posible que el cliente no siempre pueda atender las demos, es
recomendable que lo haga con la mayor frecuencia posible. Además de las
ventajas comentadas arriba, con su asistencia aumentaremos su confianza.

### Regla del Boy Scout

Los _Boy Scouts_ tienen una sencilla regla; "deja el campamento siempre más
limpio que cuando llegaste". Aplicada al software, esta regla se traduce en
_"deja el código más limpio en el commit que cuando hiciste checkout"_. No es
necesario que sean grandes refactorizaciones. Pueden ser algo tan pequeño como
renombrar una variable o una función para que sea más clara.

Debemos tener en cuenta, no obstante, que estos cambios deben ser mejoras
objetivas. No debemos modificar código por criterios subjetivos para evitar
_peleas en el código_. Aplicado de nuevo a los Boy Scouts, no se trata de
cambiar los trapos de cocina del segundo cajón al tercero, sino de limpiar los
cajones.

### Pomodoro Technique

La [técnica del pomodoro](http://www.pomodorotechnique.com/) es una técnica de
gestión del tiempo que recibe su nombre de los temporizadores en forma de
tomate que podemos encontrar en muchas cocinas. Consiste en poner el
temporizador en 25 minutos y tratar de trabajar durante ese tiempo sin
interrupciones y con la máxima concentración. Pasados los 25 minutos,
descansamos 5. Volvemos a poner el temporizador. Al cabo de cuatro pomodoros,
tomamos un respiro más largo.

No todo el mundo puede permitirse está técnica porque no todo el mundo puede
bloquear todas las interrupciones entrantes. Pero cuando puedes aplicarla,
vale la pena porque aumenta tu concentración y permite sacar mucho mayor
partido del tiempo que pasas en la oficina. Además, gracias al tomate no te
olvidas de tomarte los descansos necesarios.

Personalmente encuentro especialmente útil la técnica del pomodoro en los días
en los que, por cualquier motivo, estoy más disipado o me cuesta concentrarme.

## Fundamentos de la calidad en el código

Con este artículo no pretendo tratar en profundidad detalles sobre la
implementación del buen código. Para saber más, os recomiendo empezar con el
estupendo [Clean Code](http://www.amazon.com/Clean-Code-Handbook-Software-
Craftsmanship/dp/0132350882). Por el momento vamos a tratar unos pocos de los
denominados [bad smells](http://en.wikipedia.org/wiki/Code_smell) del código.

### Coding standards

Los [coding standards](http://en.wikipedia.org/wiki/Coding_conventions) son
convenciones sobre el estilo de codificación para una determinada plataforma o
lenguaje. Son recomendaciones sobre aspectos muy concretos del código como
tabulaciones, espacios en asignaciones o camelCase. Ser respetuoso con los
coding standards va a afectar muy positivamente a uno de los principales
puntos de este artículo; la propiedad colectiva del código.

Para garantizar que se están siguiendo las recomendaciones dadas por los
coding standards, algunos equipos optan por programar scripts que analizan el
código justo antes de ser contribuído. Esto puede lograrse utilizando por
ejemplo los disparadores de los sistemas de control de versiones modernos
(hook pre-commit). El hook pre-commit se ejecuta siempre justo antes de
contribuir el código. En este momento es posible utilizar herramientas como
[CodeSniffer](http://pear.php.net/package/PHP_CodeSniffer/redirected) (PHP)
para analizar los archivos contribuídos. Si estas herramientas no validan el
código, el _commit_ es rechazado de forma automática.

### Claridad

Es muy extraño que el código se escriba una vez y permanezca inmutable toda su
vida útil. Normalmente entrarán nuevos requisitos y modificaciones sobre los
existentes que exigirán cambios en el código inicial. El código se escribe una
vez, pero se modifica constantemente. Por ello, escribir código comprensible y
autoexplicativo nos va a permitir afrontar futuras modificaciones con mayor
agilidad.

Ser claro es sinónimo de ser autoexplicativo. Escoger correctamente nombres de
variables y funciones para que describan de manera precisa para qué son
utilizadas puede ser un esfuerzo para el desarrollador, pero va a ahorrar
mucho trabajo en futuras intervenciones. El código abigarrado, complejas
expresiones condicionales o el abuso de comentarios son señales de mala
calidad en el código.

### Duplicidad

Si queremos seguir el principio _Don't Repeat Yourself_ deberemos limpiar el
código de duplicidades. Las duplicidades involucran a menudo tener que aplicar
modificaciones varias veces. Además, las duplicidades tienden a crecer a
medida que el código se va viendo modificado.

### Complejidad

A la métrica más utilizada para cuantificar la complejidad en el código se le
denomina [Complejidad
Ciclomática](http://en.wikipedia.org/wiki/Cyclomatic_complexity) y determina
la cantidad de caminos independientes que pueden realizarse en un fragmento de
código.

La complejidad ciclomática es un bad smell bastante común en el código. Muchos
autores consideran que en ningún caso debería ser mayor que 10 para un método
o función. Hay muchas herramientas de análisis de código disponibles en el
mercado para medir la complejidad ciclomática del código que permiten
identificar los _puntos negros_ de la aplicación.

### Acoplamiento

El [acoplamiento](http://en.wikipedia.org/wiki/Coupling_%28computer_programmin
g%29) es una medida del grado de interdependencia de diferentes componentes
del sistema (clases, funciones, módulos...). La interdependencia es negativa
porque dificulta los cambios en el software. Un cambio pequeño en una clase de
un sistema con un fuerte grado de acoplamiento puede desencadenar un _efecto
mariposa_ de modificaciones en el código.

Existe otro tipo de acoplamiento denominado acoplamiento temporal que se
produce cuando dos acciones aparecen juntas en una función o método solo
porque ocurren a la vez. Este tipo de acoplamiento suele hacerse evidente ante
pequeñas modificaciones en la lógica de negocio.

![Sonar. Captura de
pantalla](/images/calidad_01_2012/sonar_phpUnit.png)

## Conclusiones

Este artículo no nació para ser artículo. En principio no era más que un
esqueleto para ordenar las ideas que quería exponer en una charla sobre
calidad en [Agile Levante](http://agilelevante.wordpress.com/). Pero a medida
que iba añadiendo notas sueltas sobre el papel, el esbozo fue tomando forma.
Sin darme cuenta había escrito varias páginas medianamente descriptivas y ya
no había vuelta atrás. No podía parar de escribir.

He redactado este artículo en cinco intensos días. He tenido que excavar en mi
memoria para rescatar ideas que empezaban a quedarse enterradas. Me he
desesperado intentando expresar ideas que no conseguía explicarme a mí mismo.
Al final, algo ha salido. Mi experiencia de un año dedicado en buena parte al
estudio de la calidad del software.

Los agradecimientos se los reservo a [Emma
López](http://twitter.com/#!/hell03610) por su apoyo y sus comentarios, y por
brindarme la oportunidad de dar la charla con una audiencia tan distinguida. A
ellos también por venir a escucharme y compartir sus conocimientos. A [Carlos
Ble](http://www.carlosble.com/) por sus discursos inspiradores - la estructura
inicial de este artículo es un copy-paste de una charla suya sobre TDD - y a
los autores que, [a través de los
libros](http://www.carlescliment.com/blog/2011-un-a%C3%B1o-de-libros), me
ayudaron tanto el año pasado.

A todos ellos, ¡gracias!

## Historial de revisiones

  * 20/01/2012 - Refactorización. Eliminado texto sobrante.
  * 05/01/2012 - Primera revisón.

[![Creative Commons License](http://i.creativecommons.org/l/by-nc/3.0/88x31.png)](http://creativecommons.org/licenses/by-nc/3.0/)

Calidad e Integración Continua. Una introducción by
[Carles Climent Granell](/) is licensed under a [Creative Commons Attribution-NonCommercial 3.0 Unported License](http://creativecommons.org/licenses/by-nc/3.0/).

