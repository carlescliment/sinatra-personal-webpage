---
title: Curso Metodologías Ágiles y TDD, parte I
date: 2014-07-07
author: Carles Climent Granell
license: All rights reserved to Carles Climent Granell. This material cannot be reproduced or used without express authorization of the author, as a whole or fragmented.
---


# Curso de Metodologías Ágiles y TDD, Parte I.

## Historias de Usuario

### Introducción

#### Qué es una historia de usuario

Una historia de usuario es la descripción de una funcionalidad que aporta valor a un usuario del sistema. Se compone de tres aspectos:

* La descripción de la historia (Card).
* Las conversaciones que especifican los detalles sobre la misma (Conversation).
* Tests y detalles de documentación que especifican cuándo la historia está lista (Confirmation).

```
A traveler can make reservations in hotels
```

Una historia de usuario suele representarse en un trozo de papel o tarjeta y simboliza el vínculo entre el desarrollador y el dueño del producto. Su valor es efímero, empieza cuando surge la necesidad de un nuevo desarrollo y termina una vez se entrega la funcionalidad. Por lo tanto, a largo plazo una historia de usuario no aporta valor documental, ni contractual.

Teniendo en cuenta la naturaleza cambiante del software y de las necesidades de negocio al que éste responde, las historias de usuario suponen un gran ahorro respecto a la tradicional documentación exhaustiva del desarrollo en cascada. En lugar de mantener innumerables versiones sobre la documentación, ésta se escribe a medida que el software evoluciona mediante los tests de aceptación. **Los tests son la única documentación viva y veraz de las necesidades que la funcionalidad cubre.**

#### Historias épicas e historias microscópicas

Las historias demasiado grandes reciben el nombre _épicas_. Las historias épicas suelen ser más difíciles de estimar y planificar, y se componen de varias sub-funcionalidades. Una historia épica puede descomponerse en otras más pequeñas:

```
A traveler can make reservations in hotels
```

```
- A traveler can search hotel rooms by city, price and quality
- A traveler can access to the room details.
- A traveler can place reservations on available rooms.
- The hotel wants to be informed when a reservation is placed on its rooms.
```


Las historias microscópicas son aquellas que abordan con demasiado detalle una funcionalidad, y que están tan cerradas que no dan lugar a conversación. La proliferación de estas historias tiene un impacto negativo en la estimación global y suponen mayor esfuerzo en su gestión, ya sea mediante tarjetas de cartón o con herramientas informáticas. Por ello es aconsejable unificar estas microhistorias en historias con mayor entidad.

```
- A traveler can see the hotel address.
- A traveler can see the hotel telephone.
- A traveler can see the hotel email
- ...
```

```
- A traveler can see the hotel's contact details.
```


#### Quién escribe las historias

Las historias de usuario se escriben en un lenguaje no-técnico, cercano al dominio del negocio al que pertenecen. Esto facilita que sea el propio cliente (Product Owner) el que escriba las historias. Sin embargo, hay algunos inconvenientes que dificultan que el _Product Owner_ se encargue él mismo de realizar esta tarea.

- Muchos _Product Owners_ suelen encontrar poco tiempo para especificar sus propias necesidades.
- Escribir historias de usuario requiere de cierta experiencia previa o entrenamiento.
- A menudo las necesidades no dependen de una sola persona, sino de varios departamentos, por lo que existen varios _Product Owners_. Reunir a las personas involucradas en determinadas funcionalidades puede ser difícil, cuando no imposible.

Por ello es frecuente utilizar _proxies_ del _Product Owner_. Los proxies son miembros del equipo de desarrollo o de otras áreas de la empresa que, por su mejor conocimiento del dominio de negocio, _representan_ al Product Owner participando en la redacción de las historias. Un _proxy_ puede ser una única persona o un equipo formado por diseñadores, testers, desarrolladores, etc...

En cualquier caso, es importante que el _Product Owner_ valide las historias y sus prioridades.



### Cómo escribir historias

Las historias de usuario deben ser:

* **Independientes**. Las dependencias entre historias llevan a problemas de planificación y priorización.

```
- A traveler can make a reservation paying with a Visa card.
- A traveler can make a reservation paying with a MasterCard.
- A traveler can make a reservation paying with a American Express.
```
Las anteriores historias son muy interdependientes. La realidad es que no todas ellas tendrán el mismo coste de desarrollo, casi con toda seguridad será la primera la más costosa.

Por lo tanto tal vez sea mejor reformular las anteriores historias:

```
- A traveler can make a reservation paying with one type of credit card.
- A traveler can pay with two credit card alternatives.
```



* **Negociables**. Las historias son negociables y no representan ningún contrato. Por ello es importante no reflejar detalles de implementación que pueden cambiar durante el desarrollo. Los detalles, por tanto, forman parte de las conversaciones (vis-a-vis, emails, etc...) que se llevarán a cabo mientras se implemente la historia.

* **Valiosas para el cliente**. Las historias de usuario deben ser valiosas desde la perspectiva del cliente. Historias como `Utilizar logger a ficheros` o `Tener una cobertura igual o mayor al 80%` no forman parte del dominio del negocio, no son priorizables y por tanto deben ser descartadas.

* **Estimables**. Las historias que no se pueden estimar suelen ser demasiado grandes o bien tratan un campo inexplorado para el equipo. Estas historias pueden descomponerse en otras más fácilmente estimables, o bien pueden ponerse _en cuarentena_ hasta disponer de la información necesaria.

* **Pequeñas**. Como hemos visto anteriormente, las historias demasiado grandes deben descomponerse en otras más pequeñas y fácilmente estimables.

* **Testables**. Las historias deben especificar tests de aceptación que demuestren que la historia está realizada. Estos tests deben ser además automatizables para garantizar que el valor aportado se mantiene durante la evolución del software.


### Roles

En algunos proyectos se tiende a simplificar los roles del sistema generalizándolos bajo el término `Usuario`. Una mejor definición de los distintos roles que utilizarán el sistema permitirá detectar las necesidades a cubrir desde una óptica más cercana a los receptores del valor.

Para identificar roles es importante la participación del _Product Owner_ y de tantos desarrolladores como sea posible. Cada participante toma unas tarjetas de una pila, escribe los roles que se le ocurran y los deposita en un tablón o mesa. Durante el brainstorming no existe debate, solo se escriben roles y se depositan.

Una vez terminado el brainstorming, las tarjetas se colocan por proximidad según se solapen unos roles con otros. Una vez colocados, algunos roles se pueden unir, otros se pueden refinar, etcétera. También se descartan aquellos roles que no son importantes en el proyecto.


### Estimar y planificar historias

Una vez escritas las historias de usuario, el equipo se reúne con el fin de estimarlas. La técnica más reconocida se conoce como **estimación con Story Points**. Un _Story Point_ es una unidad de medida que no tiene un valor concreto en sí mismo. Simboliza el _esfuerzo_ estimado para terminar una tarea _en relación con las demás_.

El valor de un _Story Point_, por tanto, es otorgado por el equipo. Una historia que _pese_ 1 SP será aproximadamente el doble de costosa que una historia de 2 SPs.

En metodologias ágiles, la estimación no supone un contrato de ningún tipo, por lo que no puede utilizarse para _presionar_ al equipo si la estimación no se cumple.

Le conoce como **velocidad** a la cantidad media de _Story Points_ que un equipo puede liberar durante una iteración.

Una vez estimadas las historias, el _Product Owner_ es el responsable de priorizarlas y decidir qué historias se desarrollarán en cada iteración. Las iteraciones son _bolsas_ cuya capacidad depende de la velocidad del equipo. Si la velocidad media en las últimas iteraciones es de 25, el _Product Owner_ seleccionará un conjunto de historias cuyo peso total **en ningún modo sobrepase los 25 SPs**.

Cuando un equipo se inicia en metodologías como SCRUM no conoce su velocidad. Una técnica para empezar es estimar _a ojo_ las primeras tres iteraciones, y a partir de ahí extraer una media.


### Definición de hecho

Una historia se considera terminada cuando las pruebas de aceptación están automatizadas y pasan _en verde_. **Sin tests, la historia no puede considerarse terminada**.



### Cómo medir la evolución del proyecto

El **burndown chart** permite medir de una manera muy gráfica la evolución del proyecto. Consiste en un gráfico cuyo eje vertical son los SPs totales del proyecto, y cuyo eje horizontal es el número de iteraciones previstas. En un color se dibuja la linea que representa el **progreso estimado**, que unirá el punto más alto del eje Y con el más alejado del eje X.

A medida que terminen las iteraciones se irá dibujando la línea que representa el **progreso real**.

![Burndown chart](/images/curso-agil-xp-julio-2014/burndown.png)


## SCRUM

SCRUM es un **Framework de desarrollo ágil, iterativo e incremental** para la gestión de proyectos.

### Roles

* El **Product Owner** representa a los **stakeholders** y es la voz del cliente, encargado de escribir y priorizar las **historias de usuario**.
* El **Equipo de Desarrollo** es el encargado de transformar las historias en funcionalidades.
* El **Scrum Master** es un facilitador cuya tarea es eliminar cualquier impedimento que pueda afectar al equipo.


### Eventos

* El **Sprint** es la unidad básica de desarrollo de Scrum. Tiene una duración específica y fija a lo largo del tiempo, siendo dos semanas la más típica, y se compone de un conjunto de historias de usuario que el equipo de desarrollo se compromete a entregar.
* La **reunión de planificación** se realiza al principio de cada Sprint. Es una reunión **limitada en el tiempo** (timeboxed), en la cual se prioriza el trabajo a realizar y se construye el _Sprint Backlog_.
* El **Daily Standup meeting** es una reunión diaria, limitada en tiempo (15 minutos aprox.), donde cualquiera puede asistir, incluso no-desarrolladores. Para que la reunión sea lo más breve posible se realiza de pie y frente al panel Scrum. Por turnos, cada desarrollador contestará a tres preguntas:
    - ¿Qué hiciste ayer?
    - ¿Qué vas a hacer hoy?
    - ¿Hay algo en lo que podamos ayudarte?
* La **Demo** se realiza al final del sprint, y en ella se presenta a los stakeholders/clientes el trabajo realizado.
* La **Retrospectiva** es la última reunión del Sprint, donde se persigue la mejora continua a través de dos preguntas: ¿Qué ha ido bien en este sprint? ¿Qué podemos mejorar?


### Artefactos

* El **Product Backlog** es una lista de todo aquello que es necesario realizar para entregar un producto.
* El **Sprint backlog** es el trabajo que deben realizar los desarrolladores en el sprint actual.
* El **Burndown chart** es un gráfico que visibiliza la evolución real del proyecto respecto a la evolución estimada.


## Kanban

Kanban (en japonés, _panel_), es una metodología mucho más libre de reglas que Scrum. Se basa en seis prácticas:

* **Visualiza el trabajo** generalmente a través del panel.
* **Limita el WIP** para estimular que las historias atraviesen lo antes posible.
* **Monitoriza el flujo de trabajo** para obtener feedback.
* **Todas las reglas deben ser explícitas** para evitar discusiones.
* **Impulsa el feedback** a través de retrospectivas y otras prácticas.
* **Mejora continua**.

## Las 12 prácticas de Extreme Programming

* Las **User Stories** son el corazón de la planificación ágil.
* **Iteraciones cortas** que permitan un feedback rápido y correcciones a tiempo.
* Uso de **metáforas**, lenguaje compartido por clientes y desarrolladores.
* **Propiedad colectiva** del código.
* **Coding standards**
* **Simplicidad**
* **Refactoring**
* **Testing**
* **Pair programming**
* **Continuous Integration**
* **Ritmo de trabajo sostenible**
* **Participación y compromiso del cliente**.





### Bibliografía:
- [User Stories Applied](http://www.amazon.com/User-Stories-Applied-Software-Development/dp/0321205685/)
- [Extreme Programming Explained](http://www.amazon.com/Extreme-Programming-Explained-Embrace-Change/dp/0201616416)
- [Agile Estimating and Planning](http://www.amazon.com/Agile-Estimating-Planning-Mike-Cohn/dp/0131479415)
- [SCRUM From The Trenches](http://www.amazon.com/Scrum-Trenches-Enterprise-Software-Development/dp/1430322640)
- [Lean Software Development](http://www.amazon.com/Lean-Software-Development-Agile-Toolkit/dp/0321150783)
- [Artículo sobre SCRUM en la Wikipedia](http://en.wikipedia.org/wiki/Scrum_(software_development))
- [Artículo sobre Kanban en la Wikipedia](http://en.wikipedia.org/wiki/Kanban_(development))
- [Extreme Programming: Do these 12 practices make perfect?](http://www.techrepublic.com/article/extreme-programming-do-these-12-practices-make-perfect/)
