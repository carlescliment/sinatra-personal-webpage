---
title: El software testing y la revolución industrial
date: 2012-11-19
---

### Introducción

Esta semana se ha celebrado en el [ITI](http://www.iti.es/) de Valencia uno de
los eventos con más tradición dentro del estado español en cuanto a software
testing; el [VLCTesting](http://vlctesting.es/conferenceDisplay.py?confId=7).

Este evento tiene una naturaleza distinta a la de otros grandes eventos que
suelo frecuentar, más relacionados con plataformas de software libre, open
spaces y otros formatos como el pasado CodeMotion. Distinta en el público
objetivo, mucho más especializado, en el perfil de los ponentes, mucho más
corporativo, y en el objetivo de las ponencias y el networking, mucho más
comercial.

Lo que ha quedado patente en esta edición del VLCTesting es el
esfuerzo de los organizadores por oxigenar un mundo quizá un tanto endogámico
con otros puntos de vista. Estas nuevas perspectivas aparecieron con dos
nombres; desarrollo y agile. La organización de talleres para desarrolladores
y la presencia de estos como ponentes y en la mesa redonda dan buena fe de
ello.

No miento si os digo que hacía tiempo que no sentía una experiencia tan
enriquecedora, y es que en este VLCTesting tuve la oportunidad de adentrarme
en un mundo, el de los testers funcionales, del que solo tenía rumores vagos y
referencias en apuntes de la universidad.

Aparte de haber conocido a gente
estupenda y con una actitud e ilusión que ya quisieramos para nosotros en el
mundo del desarrollo, me quedé impregnado de una sensación que creí captar en
el ambiente; la preocupación de los testers tradicionales por un futuro que
les resulta incierto. Incierto por la ocupación imparable por parte de los
desarrolladores de espacios que hasta hace poco creían inexpugnables, y por el
miedo que les provoca el avance de la automatización del testing, que algunos
juzgaron en el evento de hostil e inútil.

### Los testers como gremio

![Testers como gremio](https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcRfYUak6mQX0Z21p33DN9aeycFSy0W_Y6iZfsqa4TIEQSVHnQDN) 

Cuando pienso en este rechazo a la
automatización y la angustia que quedó patente en algunas de las preguntas de
la mesa redonda, mi cabeza evoca las clases de historia en el instituto sobre
la Revolución Industrial. Una revolución que enfrentó a un sector hegemónico
durante siglos, los gremios, con otro incipiente y voraz, basado en la
mecanización de los procesos. Me parece una analogía cercana tanto por la
naturaleza del cambio que se avecina como por la reacción ante él.

Durante el primer día del evento se habló de la relación entre testers y developers como
una contraposición. O, mejor dicho, como si ambas actividades fueran
excluyentes una de la otra. Los testers concedían (y pedían) a los
desarrolladores la automatización de tests unitarios, pero en ningún momento
se concebía la posibilidad de que los segundos avanzaran más allá. La
automatización de pruebas funcionales o de aceptación quedaba, por tanto,
vedada a los testers profesionales. Es más, en los casos en que se había
intentado la automatización de pruebas funcionales había resultado un completo
desastre. Después de un esfuerzo enorme en automatizarlas resulta que, a los
pocos meses, ¡las pruebas habían dejado de funcionar!

Estos razonamientos me hacían sospechar que algo en ese proceso de automatización no se había hecho
correctamente. En primer lugar, eran los testers los que, con los
conocimientos justos para codificar las pruebas, se habían encargado de
automatizarlas. No pongo en duda la profesionalidad ni los conocimientos de un
tester en cuanto a su campo, claro está, pero cuando hay automatización de por
medio falta una pizca de "cultura del código". Por ejemplo, a un desarrollador
no le sorprende en absoluto que los tests que llevan meses sin lanzarse dejen
de funcionar. Los desarrolladores sabemos que, igual que una enredadera que
crece constantemente en el jardín, al código hay que orientarlo, podarlo y
vigilarlo. ¡No se mantiene solo!

Me costó no llevarme las manos a la cabeza cuando, en el Autum Test, en una entrevista a un tester de alto rango en
Zurich Seguros, este contaba que habían elaborado una lista de 6.500 tests
cases que ejecutaban a mano. Cuando había un despliegue a la vista, enviaban
los test cases a un grupo de indios off-shored que se encargaban de hacer las
pruebas pertinentes. Aunque la mano de obra india es barata, era imposible
hacer las 6.500 pruebas, por lo que agrupaban por funcionalidades y solo
reproducían aquellas que podían verse afectadas por las modificaciones en el
software. En Zurich Seguros también habían automatizado unos 1.500 test cases,
pero estos habían (también) dejado de funcionar y por lo tanto estaban
abandonados.

No me quiero imaginar el dinero que Zurich Seguros está tirando a
la basura por decisiones de aquellos que se resisten a la automatización. No
solo por el dinero que gasta en indios, que no será mucho, pero sí en el
interminable frontón que debe resultar la fase previa a un despliegue, con el
ciclo de reporte de errores y aplicación de parches.

Encontré otro caso flagrante de anacronismo en el sector en una diapositiva de una presentación
en la que se dijo que "no se podía testear todo". En esta diapositiva se
planteaba (más o menos) una aplicación con 15 pantallas y 70 formularios de 10
campos cada uno, lo que implicaría un total de 15x70x10=10.500 pruebas. El
caso no era exactamente así pero se entiende la aritmética que se estaba
aplicando. El caso es que traducían estas cifras a tiempo y el cálculo
valoraba el coste necesario en testear una aplicación en varios años. Este
razonamiento servía para que la ponente expusiera la solución ofrecida por su
empresa; un servicio de priorización de funcionalidades de la aplicación que
permitía descartar del testing aquellas funcionalidades con menos impacto. Si
alguien conoce bien las pruebas de aceptación o, mejor aún, ha tomado contacto
con BDD se dará cuenta del aritmético disparate.

Así que en este escenario llegamos los desarrolladores, desembarcamos con nuestras herramientas y
bastante insolencia, y les decimos que todo eso que llevan haciendo durante
años es una completa pérdida de tiempo y dinero.

### La automatización inevitable y el nuevo papel del tester

En esta Revolución Industrial nos ha tocado el papel de malos.
Venimos a sustituir a estos artesanos del testing con nuestras máquinas.
Porque aunque todavía no lo saben, tenemos herramientas para sustituir sus
clicks de ratón casi al completo. Los que llevamos ya un tiempo estudiando y
practicando esto del testing automático sabemos la seguridad que nos otorga.
Aún somos pocos y el testing desde desarrollo es una actividad marginal, pero
el día en que la industria se dé cuenta de su potencial y el ahorro que
supone, ese día, será un día oscuro para los testers tradicionales.

Hemos superado de largo el testing unitario. Tenemos test de integración, tests
funcionales. Podemos traducir palabra por palabra lo que el cliente nos dice
en las pruebas de aceptación, y convertirlas en un test automático. Tenemos
herramientas que permiten simular las acciones de un humano. Y lo que es más
importante, lo hacemos más rápido y no nos cansamos. Podemos ejecutar los
mismos tests una y otra vez, con la misma precisión y sin quejarnos. Sin más
coste que la energía que consuman nuestras computadoras. En estas condiciones,
¿hay espacio para el tester del futuro?

Uno de los asistentes dejó la siguiente cita "un desarrollador no debería testear su propio código". Es una
cita interesante y que tiene una parte de verdad. Los desarrolladores abrimos
caminos con el software y, en el test, recorremos esos mismos caminos. Giramos
en el test los mismos engranajes mentales que en el código, y esto nos impide
salirnos de los márgenes. ¿Significa eso que no deberíamos testear? No,
significa que necesitamos que otros exploren caminos que no aparecen en
nuestras cabezas cuadriculadas. De manera que completaría la cita del
siguiente modo: "un desarrollador no debería testear su propio código ÉL
SOLO".

Ese es, en mi opinión, el papel del tester del futuro. Necesitará una
cabeza brillante e imaginativa. Dejará el cómodo trabajo de encontrar bugs
rellenando una y otra vez un formulario y tendrá que reforzar sus habilidades
en el testing exploratorio. Será un psicólogo, un experto en usabilidad y un
descubridor nato. Creo que cuando la automatización se extienda se van a
producir muchos despidos. Aquellos testers que no sepan adaptarse los
sufrirán. Pero los que queden aguzarán aún más su ingenio, siempre en su afán
de salirse de los márgenes.

### Distintos puntos de vista

También hubo mucho debate entre los desarrolladores en cuanto a la calidad del
software. De una parte los partidarios de la calidad formal, representada por
la ISO 25000 y sus procedimientos. De otra los que pensamos que la calidad del
software nace en los individuos y no en las empresas de "Quality As A
Service", y va más allá de las normativas y las métricas. Pero esa... es otra
historia.

### Reacciones

Os pongo aquí una respuesta interesantísima de un tester profesional con quien
tuve la oportunidad de compartir unos momentos de charla, [Tomislav
Delalic](https://twitter.com/TDelalic), titulada
[El Software Testing y la Revolución Industrial visto por un tester](http://sinfoniadetesteo.blogspot.com.es/2012/11/el-software-testing-y-la-revolucion.html).

