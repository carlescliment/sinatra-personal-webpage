---
title: Lo que Démeter esconde
date: 2013-04-25
---

### Introducción

Hace tiempo que no pasaba por aquí a dejar mis reflexiones, seguramente porque
últimamente tengo muy poco tiempo para reflexionar. También porque desde que
empecé mi retiro particular me muevo menos entre eventos, y tengo menos
oportunidades de contrastar puntos de vista. Ayer [Raquel Moreno](http://www.l
inkedin.com/profile/view?id=203128486&authType=NAME_SEARCH&authToken=3L66&loca
le=es_ES&srchid=497e61f0-f40f-4638-a91b-d00a07afb3db-0&srchindex=1&srchtotal=1
76&goback=.fps_PBCK_*1_Raquel_Moreno_*1_*1_*1_*1_*2_*1_Y_*1_*1_*1_false_1_R_*1
_*51_*1_*51_true_*1_es%3A0_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_
*2_*2&pvs=ps&trk=pp_profile_name_link) ofreció un simpático seminario llamado
"el cajón de sastre del desarrollador" en el que nombró un montón de buenas
prácticas y conceptos, y encendió esa chispita que me empuja a coger el iPad y
ponerme a redactar.

A ver si pronto publican el material y, si me da su permiso, lo enlazo.

### ¿Qué es la Ley de Démeter?

Podéis encontrar una [definición de la Ley de Démeter en la
Wikipedia](http://en.wikipedia.org/wiki/Law_of_Demeter). Lo que pretende es
reducir el acoplamiento en el sistema haciendo que las clases sepan muy poco
de cómo están construídas sus colaboradoras. Básicamente consiste en evitar
los chorongos como:

```ruby
# chorongo
from = mailer.getConfiguration().getParameterBag().get('default_from');
appSettings.set('mailer_from_address', from);
```

Invocar esta serie de llamadas en cadena a objetos dentro de objetos implica
conocer la estructura interna de la clase principal y, además, el mínimo
cambio en esta estructura afectará a todos aquellos sitios donde se esté
invocando dicha cadena. La solución más extendida es crear un accesor que
proporcione directamente dicho dato y oculte la estructura interna:

```ruby
# con accesor
from = mailer.getDefaultFrom();
appSettings.set('mailer_from_address', from);
```

Imagino que hasta aquí todos estaremos de acuerdo en que esto de **la Ley de
Démeter es cosa buena**. Ahora bien, me gustaría que pensásemos en las
consecuencias; al añadir el método `getDefaultFrom()` a la clase contenedora,
nos veremos obligados también a añadirlo a la interfaz que ésta implementa,
¿no?. Bueno, ¿solo eso?. No parece grave.

```
# mailer interface
interface Mailer {
    // ... mailer methods
    // ...

    // Demeter methods
    public getDefaultFrom();
}
```

Ahora imaginemos que al cabo de unos días necesitamos acceder a más parámetros
de las clases hijas, por lo que añadiremos los métodos correspondientes a la
clase...

```
// la llamada
mailer.getConfiguration().getParameterBag().get('mime_type');
// se convierte en
mailer.getMimeType();

// la llamada
mailer.getEncoder().encode(message)
// se convierte en
mailer.encode(message)
```


... y modificamos la interfaz en consecuencia.

```
# mailer interface
interface Mailer {
    // ... mailer methods
    // ...

    // Demeter methods
    public getDefaultFrom();
    public getMimeType();
    public encode();
}
```

Y así sucesivamente...

Si nuestra clase contenedora contiene varios objetos, un día encontraremos que
su interfaz pública se ha hecho gigantesca. Además, es posible que muchos de
esos métodos correspondan a soluciones de nuestro ámbito particular, por lo
que otras implementaciones tendrán que añadir todos esos métodos vacíos.
Seguramente concluyamos que, bueno, tal vez siguiendo la Ley de Démeter hemos
contravenido otra buena regla; la de [Una Sola
Responsabilidad](http://en.wikipedia.org/wiki/Solid_%28object-
oriented_design%29).

### ¡Di, amigo, y entra!

Creo que ya he enlazado otras veces en este mismo blog un artículo de la
biblioteca pragmática: [Tell, don't ask](http://pragprog.com/articles/tell-
dont-ask). Para mí arroja mucha luz sobre el tema.

La mayoría de violaciones a la ley de Démeter que he encontrado se deben al
abuso de accesos a atributos de una clase, es decir, que por mucho que sigamos
esta ley no significa que estemos encapsulando correctamente los datos ya que
accedemos a ellos igualmente, aunque sea **por atajos**.

Siguiendo con el ejemplo anterior, en el que exponía una aplicación hipotética
que añadía a la configuración de la app la configuración del mailer, ¿ qué
pasaría si en lugar de extraer los parámetros de configuración, la aplicación
le ordenase al mailer "configúrame" ? Deberíamos hacer cierto trabajo
preliminar, claro. La clase mailer debería implementar, por ejemplo, la
interfaz Configurator. La aplicación, por su parte, debería implementar la
interfaz Configurable, de manera que ambas estableciesen un modo de
comunicarse.

```
#inversión de control
interface Configurator {
    public configure(Configurable configurable);
}

interface Configurable {
    public setParameter(name, value);
}

class Mailer implements Configurator {
    // ...
}

class Application implements Configurable {
    // ...
}

app = Application();
mailer = Mailer();
mailer.configure(app);
```

¿No estamos, ahora sí, reduciendo hasta el mínimo lo que unas clases conocen
de otras? ¿No estamos facilitando la implementación de sus interfaces? ¿No
estamos favorenciendo un diseño con clases "promiscuas" que podemos compartir
entre sistemas? ¿No ofrecemos así más honores a la diosa? ¿Qué opináis al
respecto?

### Conclusiones

Vaya por delante que de ninguna manera estoy diciendo que debemos saltarnos la
Ley de Démeter. Lo que creo es que a menudo añadir métodos para cumplir con
dicha ley es **la solución fácil**. Cuando nos vemos obligados a hacerlo una y
otra vez... ¿no es posible que el problema esté en nuestro estilo de
programación? ¿No estamos "maquillando" los defectos de nuestra aplicación
implementando atajos?

Preguntémonos qué es lo que Démeter esconde.

