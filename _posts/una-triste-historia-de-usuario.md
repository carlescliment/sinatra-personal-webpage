---
title: Una triste historia de usuario
date: 2012-03-07
---

Ayer en nuestras oficinas tuvimos una charla de [Xavi
Gost](https://twitter.com/#!/xav1uzz) sobre historias de usuario. En las
últimas semanas, mejorar nuestra forma de identificar los requisitos es uno de
los frentes más intensos en Aureka Internet, y tuvimos oídos y ojos bien
abiertos en las más de dos horas que duró la reunión. En algún momento de la
charla Xavi comentó algo sobre _"roles tóxicos"_. No profundizó en el concepto
pero creo que varios compañeros tuvimos la sensación de que esas dos palabras
habían iluminado una bombilla en alguna parte.

Hoy hemos tenido un problema con una historia de usuario. Estamos
desarrollando una aplicación en la que los jugadores participan en
competiciones y, en función de su clasificación, ganan puntos. Simple,
¿verdad?. Bueno, en realidad tiene algo más de miga pero no viene al caso. La
historia en cuestión es la siguiente: ` Como administrador quiero establecer
la clasificación de una competición para que se actualicen los puntos de los
jugadores. `

Bien, esta historia de usuario plantea algunos problemas. El primero es que
parece que está hablando de dos cosas distintas. Por una parte establezco una
clasificación y, por otra, de alguna manera, se actualizan los puntos de los
jugadores. Esta historia se centra en la primera parte, por lo que supondremos
que hay una historia posterior en la que se describe quién y por qué quiere
actualizar los puntos. Esto ya huele mal. Sigamos.

Así que, como administradores, queremos establecer una clasificación. La
consecuencia directa en nuestra CPU mental es que el administrador necesita
una interfaz donde poner una lista ordenada de jugadores. En una competición
puede haber una clasificación de 60 jugadores, por lo que se añaden problemas
de usabilidad. ¿Usamos un drag and drop para ordenar una tabla? Aún así no
parece muy cómodo. Podríamos mostrar campos de texto en los que introducir el
nombre del jugador. Pero, ¿Y si lo escribo mal? Bien, podemos usar
autocompletado para que el sistema busque los jugadores en nuestra base de
datos a medida que vamos escribiendo. Uhm...

Nos dicen que es posible que aparezcan en la clasificación jugadores que aún
no tenemos en la base de datos. Esto implica que, o bien obligamos al
administrador a introducir estos jugadores antes de introducir la
clasificación, o bien hacemos que el sistema los cree automáticamente si
encuentra un nombre no reconocido. Pero... ¿Y si el administrador se equivoca
en un caracter? ¿No corremos el riesgo de introducir jugadores duplicados?

Vaya, parece que esta historia de usuario es más complicada de lo que
pensábamos. Hacemos unos cuantos bocetos y ninguno nos convence. Esta interfaz
de ninguna manera va a resultar cómoda. Vamos a repasar el enunciado.

` Como administrador quiero establecer la clasificación de una competición
para que se actualicen los puntos de los jugadores. `

En primer lugar. Como administrador. ¿De verdad necesito establecer la
clasificación? ¿Tengo que ser yo? ¿Por qué?

Que los puntos de los jugadores se actualicen parece un objetivo lícito. ¿Para
qué quiero que se actualicen los puntos de los jugadores? ¿La actualización
aporta valor per se?

Reescribamos la historia de otro punto de vista. ` Como jugador quiero que mis
puntos se actualicen de acuerdo a mi clasificación en las competiciones para
poder competir con otros jugadores y hacer mi experiencia de usuario más
divertida. `

¡Vaya! ¡Ya no tenemos administrador! Habiéndonos quitado ese rol de por medio
todo parece más claro. Nos podemos quitar de encima algunos prejuicios.
Sabemos que la interfaz de administración es relativamente costosa. ¿Vale la
pena?. ¿Cuál es nuestro contexto?. Uno de los factores a tener en cuenta es
que este proyecto es un _spike_. Una bala trazadora. Lanzas una funcionalidad
mínima y, si la cosa va bien, sigues con ello. Por otra parte hay que evaluar
cuántas veces se utilizaría esa interfaz. En este caso una vez por
competición. ¿Cuántas competiciones habrá en un año?

Si lo que queremos es actualizar los puntos de los jugadores, bien podemos
hacerlo con un script. El administrador nos pasa un xls o csv, lo parseamos,
creamos los jugadores que no existan en la base de datos asegurándonos de que
no haya duplicados (no hace falta un algoritmo muy complicado), invocamos a la
clase de turno para que calcule las puntuaciones y se acabó. No necesitamos
que los diseñadores nos ayuden a mejorar la usabilidad de un formulario, no
necesitamos programar nada en la GUI, ni tests en cucumber. Esta historia de
usuario de repente ha dividido su coste por 10 otorgando el mismo valor. Y
solo reformulando la historia de usuario.

El primer error de la historia original es que no aporta valor. No es una
**unidad de valor** per se. El segundo es, me parece, un caso claro de lo que
Xavi Gost llamaba "rol tóxico". Cuando no sabemos quién debe hacer algo
tendemos a pensar siempre en la figura del todopoderoso administrador. Y así
hemos acabado muchos proyectos, con mastodónticos menús de administración y
formularios acumulando polvo.

A partir de ahora, cuando una de mis historias empiece por _"Como
administrador"_ la voy a romper y reformular. Lo repetiré tres veces, y si
sigo poniendo "como administrador" en la historia, preguntaré a varios
compañeros. ¿Están de acuerdo? Entonces tal vez valga la pena diseñar una
interfaz gráfica de administración. Pero no estaré muy seguro.

