---
title: No microgestiones
date: 2012-04-14
---

Si no conocéis [el blog de Jummp](http://jummp.wordpress.com/) os recomiendo
que lo añadáis a vuestro feed reader. Siempre que
[@jummp](https://twitter.com/#!/jummpsblog) publica un nuevo post en su blog
corro a echarle un vistazo. Y esto sucede a menudo, porque jummp es el blogger
más prolífico que conozco - no lo conozco personalmente -. Pero aunque publica
varios posts diarios consigue inyectar frases brillantes con bastante
frecuencia. Por eso me pilló por sorpresa el contundente inicio de su post
[Desarrollo de software: La importancia de conocer la capacidad de
producción](http://jummp.wordpress.com/2012/04/13/desarrollo-de-software-la-
importancia-de-conocer-la-capacidad-de-produccion/).

_"¿Sabrías de una manera objetiva indicarme la capacidad de producción de una
persona de tu equipo o de algunos de tus equipos en base a algún tipo de
unidad de medida (como por ejemplo, puntos de historia de usuario)?"_

A los gestores de equipos que venimos de _las minas_ nos ocurre que nos
encantan los números. Hemos sido adiestrados, por nuestra formación y
experiencia, para el procesamiento de datos. Producir outputs a partir de
inputs. Pero nunca nos han enseñado a gestionar personas, y por eso nos
sentimos mucho más seguros manejando valores medibles y discretos.

Hace apenas unos meses hubiese suscrito el post de jummp íntegramente. Adoraba
la microgestión. Desde mi posición de responsable de calidad recogía toda la
información y me gratificaba con esa sensación de poder casi absoluto.
Revisaba al milímetro las líneas de código que cada compañero enviaba al
trunk, medía la complejidad ciclomática, la longitud de las funciones, los
nombres de variables, los comentarios... Contaba los bugs detectados en cada
iteración, y los separaba en graves y leves. Cuando durante un mes salían más
bugs de lo normal, me devanaba el cerebro buscando soluciones o
justificaciones. En mi afán de control llegué a hacer code reviews los fines
de semana desde casa.

Después me tocó gestionar al equipo como scrum master, coordinador, o como lo
queráis llamar. Y empecé a construir gráficas de productividad midiendo Story
points. Me obsesionaba conseguir que el equipo produjese más a cada iteración.
Y cuando la iteración no funcionaba según lo esperado, buscaba las causas y
los culpables. Y entonces empecé a medir la productividad individual en Story
Points.

No me daba cuenta de que estaba dinamitando la esencia misma de las
metodologías ágiles.

Si fuera posible renunciaría a los Story Points. Mediría las User Stories
según valores abstractos de lo que _cuesta_ terminarlas. Casi nada, poco,
bastante, mucho. Con esos valores sería suficiente. Pero los de arriba nos
exigen mojarnos y estimar el trabajo, y para ayudarnos en esa estimación nos
ayudamos de sucesiones numéricas para representar cada valor. 0.5, 1, 2, 3,
5... El problema viene cuando nos olvidamos de que estos valores no son más
que representaciones, aproximaciones, indicadores nada más. Una User Story de
3 Story Points no es exactamente equivalente a otra User Story de 3 Story
Points. Es más, una User Story de 3 Story Points puede acabar suponiendo mucho
menos esfuerzo que una de 1 Story Point.

Cuando empezamos a adquirir una fe ciega en el valor de los Story Points, y
nos creemos que es una unidad de medida _objetiva_, estamos cometiendo el
mismo error que los arquitectos de software en el modelo tradicional en
cascada. Pintan un diagrama de gantt de 70 tareas y te dicen que tendrán el
proyecto listo el 15 de febrero del próximo año. No, el agilismo es otra cosa.

Las estimaciones fallan porque su naturaleza es imprecisa. Lo primero que debe
hacer una empresa que acoja el agilismo es desprenderse de su obsesión por las
estimaciones y aceptar que ningún gestor es capaz de evaluar el coste de un
proyecto con precisión.

Volviendo al asunto del rendimiento individual, como bien dice jummp, un buen
gestor ya sabe qué miembros de su equipo son productivos y cuáles no. Cuando
un gestor mide los Story Points que produce un compañero, lo único que va a
conseguir es confirmar algo que ya sabe. ¿Y para qué lo hace, entonces?.
Sinceramente, el único objetivo que se me ocurre al medir los story points
individuales es utilizar este dato como arma contra el presunto perezoso. Y
este es un mal camino. Aún en el caso de que no se utilice este dato con ese
objetivo, al final se filtrará al equipo que están siendo observados de cerca.
Una cena con los compañeros con algunas cervezas de más, un comentario
inoportuno, y el daño causado al equipo será mayúsculo. Nadie quiere trabajar
en un equipo donde su esfuerzo es medido hasta el milímetro. La microgestión
denota una absoluta falta de confianza en el equipo. Y si se utilizan valores
como la suma de Story Points producidas por el individuo, entonces el
individuo se centrará en resolver cuantos Story Points pueda. Y nada más.

Hay muchos otros factores a tener en cuenta en la evaluación del desempeño de
un miembro del equipo. Y son tan difusos que no podemos _medirlos_
objetivamente, del mismo modo que no podemos medir objetivamente el coste de
un proyecto antes de realizarlo. ¿Qué aporta el desarrollador al equipo? ¿Cuál
es su grado de implicación con los objetivos de la empresa? ¿Cómo de vinculado
a ella se siente? ¿Influye en sus compañeros positiva o negativamente? ¿Cómo
de bien diseña su software? ¿Es fácil introducir modificaciones en sus
desarrollos? ¿Introduce muchos bugs y, por lo tanto, genera costes en el largo
plazo? Estas son algunas de las cuestiones que se me plantean a bote pronto.
Si lo pensamos más detenidamente, seguro que podríamos llenar folios y folios.

Las personas no somos máquinas. Incluso los desarrolladores más productivos
tendrán caídas en su productividad. Todos pasamos por dificultades en el
ámbito familiar, malos momentos emocionales o desmotivación. El gran reto de
un buen gestor - y por esto no me considero uno de ellos - es identificar
estos problemas en sus compañeros y tratar de compensarlos con los estímulos
adecuados.

Si te abrazas a las unidades de medida como a las tablas de Moisés, estás
perdiendo el foco. Estás centrándote en el procedimiento y no en el individuo.
Recordemos un fragmento del manifiesto ágil, por favor:

  * **Individuals and interactions** over processes and tools
  * **Working software** over comprehensive documentation
  * **Customer collaboration** over contract negotiation
  * **Responding to change** over following a plan

