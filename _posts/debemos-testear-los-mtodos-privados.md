---
title: ¿Debemos testear los métodos privados?
date: 2013-06-22
---

### Introducción

Como explicó [@marcos_quesada](https://twitter.com/marcos_quesada) en [su
ponencia sobre testing](http://prezi.com/fpmemrqtxna_/testing-aplicado-en-
symfony-2/) en [deSymfony](http://www.desymfony.com/), en PHP es posible
testear métodos privados. Pero... ¿debemos? Probablemente te has hecho esa
pregunta cuando tenías un método privado más o menos complejo y te faltaba
algo de confianza en él; querías asegurarte de que se comportaba tal y como
esperabas. Escribir el test después del código puede ser mejor que no escribir
tests en absoluto, pero no te reporta los beneficios de TDD. Y si mientras
haces TDD te formulas esa pregunta es que, o bien estás escribiéndo más código
del necesario en cada iteración, o no estás escuchando el feedback que los
tests te están proporcionando.

### Tus pruebas guían tu diseño, no al revés

Como sabes, una de las claves de TDD es que el test es la herramienta a través
de la cual construyes tu software. Con TDD utilizas tu método en el test antes
de que exista y, por tanto, defines la interfaz pública tal y como te gustaría
que fuera. Lo de la interfaz pública es muy importante porque quieres que ella
sea la guía que te ayude a construir el código. Y que el test te "hable", te
indique las dificultades a las que se van a enfrentar los usuarios de tu
clase. De manera que vas haciendo tests y refactorings a través de su API
pública. Eventualmente, en uno de esos refactorings, extraes una porción de
código a un método privado para darle nombre o para eliminar replicación. El
asunto es que una vez llegas a este punto... ¡esa porción de código ya está
testeada!

### Escucha lo que el test te dice

Si poco a poco vas añadiendo condiciones al método privado y te resulta
difícil reproducir esas condiciones desde el método público, sientes la
tentación de violar el [SUT](http://en.wikipedia.org/wiki/System_under_test) y
exponer el método privado para introducirle los parámetros directamente. ¡No
te estás dejando guiar!. Deja el teclado y escucha lo que los test te dicen;
te están gritando que algo va mal. ¿Tu clase está haciendo demasiadas cosas?
¿Actúa a niveles de abstración diferentes? ¿Asume demasiadas
responsabilidades? Apuesto a que es así. ¿Qué tal si aplicas Extract Class,
mueves ese código tan complejo a otra clase, la mockeas e inyectas en la clase
original, y la testeas por separado? Vamos, pruébalo. Corta y pega el código
del método privado en un método público de una nueva clase, y piensa bien el
nombre. ¡El nombre es muy importante!. ¿Ya? Vale, pues si no me has engañado y
hasta ahora habías escrito SOLO el código necesario para que pase el test,
ahora tendrás algunos test en tu clase original que ya no tienen sentido
porque establecían condiciones sobre el código que has movido. Mueve esos test
a otro testCase sobre la nueva clase, repiensa sus nombres y realiza los
cambios necesarios para que pasen. Por último añade "expectaciones" sobre el
mock del test original para asegurarte de que la comunicación entre ambos
objetos se realiza como es debido. Ya está, ¿ves? Muerto el perro se acabó la
rabia. Continúa iterando en el ciclo TDD sobre la nueva clase, añadiendo la
funcionalidad necesaria de manera incremental y usando las técnicas de
refactoring que sepas. Tal vez aparezca un nuevo método privado... pero ahora
ya sabes lo que debes hacer. Porque ahora estás escuchando. Nota: Si no te he
convencido en este post tal vez lo haga [Sebastian Bergmann](http://sebastian-
bergmann.de/), el creador de PHPUnit, al citar un párrafo del libro "Pragmatic
Unit Testing" que viene a decir lo mismo en mucho menos espacio: [Testing your
privates](http://sebastian-bergmann.de/archives/881-Testing-Your-
Privates.html).

