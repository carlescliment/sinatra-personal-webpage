---
title: El problema es la solución
date: 2014-05-28
---

> - Caray, tío, ¿ya te has cansado de escribir en inglés? - Pues ya ves, con dos posts apenas me ha dado tiempo. - ¿Pero no decías que el inglés era la lingua franca y que tal y que cual? - Efectivamente, pero es que desde que empecé con eso, por no calentarme la cabeza, no escribo. - Peroesque peroesque... tu verás, no sé, has hecho un poco el ridi haciéndote el pitinglish, ¿sabes? - Sí, bueno, ni es mi primera vez ni será la última. Que le den por culo a Shakespeare.


Empieza a llegar el calor y me va costando dormir, y en los duermevelas me vienen pensamientos, casi todos intrascendentes, que suelen acabar entre las pelusas bajo la cama. Esta vez, en cambio, como una hoja caduca ha venido a posarse un recuerdo sobre mi nariz. Como me ha parecido bastante didáctico me he obligado a levantarme de la cama a medianoche y escabullirme hacia el despacho intentando no levantar las sospechas de pareja y perros. Venga, vamos allá, escribe el post y vuelve a la cama, nadie se tiene por qué enterar de tu enfermedad.


### El portal de noticias

Hace unos años cayó en el equipo del que formaba parte el encargo de desarrollar un portal de noticias. Los requisitos eran bastante sencillos, el periódico virtual iba a tener dos columnas y las noticias tenían que ser ordenables. Aparte de eso, no mucho más, posibilidad de hacer noticias sticky que conservasen la posición aunque otras se eliminasen, imágenes embebidas, y algún etcétera.

Nos pusimos manos a la obra tres desarrolladores senior. Ninguno de nosotros era muy senior realmente, pero el hecho de habernos incorporado al mercado de trabajo antes que los otros compañeros nos daba cierta posición de privilegio. Digamos que la senioridad era una cuestión relativa.

Para añadir un poco de salsa en aquél entonces había cierta tirantez entre los miembros del equipo. Podríamos decir que el equipo de desarrollo se dividía en tres facciones: los que prudentemente no opinaban, los que opinaban una cosa, y... y bueno, la tercera facción solía ser yo. Esta ocasión no iba a ser diferente y para evitar problemas severos y debates estériles decidimos separar el desarrollo en dos. Mientras mis compañeros desarrollaban el portal yo me encargaría del backend. Eso nos daría aire y espacio a todos para trabajar a nuestras anchas. ¿Sí?


### Al día siguiente...

... la liamos. Tenía que pasar. Mis compis me propusieron organizar las columnas de acuerdo a un campo de peso. Las noticias con peso impar a la izquierda, las de peso par a la derecha. Por supuesto a mí no me pareció nada bien. Pensé que combinar lo vertical con lo horizontal era mezclar churras y merinas. Venga qué más da, vamos a sacar esto y ya está - decían -, y yo de morros. Lo que yo tenía en la cabeza, mi solución, era definir regiones y después ordenar cada una de estas según peso. Yo quería noticias "left", y noticias "right", y con su historia de pares y nones ya me estaban jodiendo. Para mí era un problema conceptual, pero de importancia crucial e irrenunciable.

No nos pusimos de acuerdo y al final llegamos a la peor solución: el backend organizaba los datos por regiones y después los daba al frontend según par o impar. Lo que se dice una señora ñapa, pero que nos dejó a todos contentos. Ahora desde la distancia me parece que no éramos un equipo muy profesional, pero bueno, ahí lo fuimos haciendo.

### Modificaciones

Como no podía ser de otra manera en esto del desarrollo soft, algunas modificaciones estaban por llegar. La más importante fue la introducción de una noticia "top" que ocupaba todo el ancho en la parte superior. No pude evitar una sonrisa malévola y una mirada desdeñosa de esas de "¿Veis? Ya os lo dije. RE-GIO-NES.". Pero los compañeros lo resolvieron en cinco minutos poniéndole peso 0 a la noticia top, y arreando, me lo tuve que tragar. Que nos dijiste qué, de qué.

El caso es que resultó que no era una sola noticia top, sino varias. Aquí ya se me escapa cuál fue la solución, pero la ñapa debió empezar a ser de monumento.

La cosa terminó así y feliz, con un sitema híbrido la mar de moderno. Podía haber sido mucho peor, podían haber metido una tercera columna y mandar al guano los pares y nones. También podían haber metido noticias que ocuparan dos columnas en cualquier posición y tirar a la basura las regiones. Por suerte nada de esto sucedió y nuestro castillo de naipes sigue, aún hoy, en pie y ofreciendo servicio.

### Conclusión

Que un equipo de tres no sea capaz de trabajar como un conjunto ya es para echarle de comer aparte, o más bien para echarlo de comer a los leones, pero no es lo que quería transmitir en este ya-demasiado-largo post.

Lo que quiero explicar es que el día 1 ya teníamos todos una solución, y esa solución no había salido del problema, sino de nuestra dura cabeza de ñu. No habíamos dedicado ni siquiera unas horas a hablar sobre el problema, no habíamos visto que la solución debía buscarse allí, y que habíamos creado un nuevo problema a través de nuestra solución.


O algo así quería explicaros, entre tanto problema y solución ya me habéis liado.














