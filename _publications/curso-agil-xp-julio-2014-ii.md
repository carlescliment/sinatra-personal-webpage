---
title: Curso Metodologías Ágiles y TDD, parte II
date: 2014-07-14
author: Carles Climent Granell
license: All rights reserved to Carles Climent Granell. This material cannot be reproduced or used without express authorization of the author, as a whole or fragmented.
---


# Curso de Metodologías Ágiles y TDD, Parte II

## Entornos higiénicos con Vagrant

### Introducción

Cuando un programador empieza su andadura en el desarrollo del software, no suele pasar mucho tiempo hasta que escucha por primera vez la expresión _"en mi ordenador funciona_. Tanto es así que la frase se ha convertido en objeto de chistes, memes e incluso camisetas.

![Works on my machine meme](works-on-my-machine-meme.jpg)

El problema surge de la disparidad en los distintos entornos del staging, desde los equipos de desarrollo locales hasta el servidor de producción, sin olvidar los servidores de integración y testing. Antes de la irrupción de la [cultura DevOps](http://en.wikipedia.org/wiki/DevOps) se solía considerar la parte de operaciones como un área independiente de desarrollo. Los **DevOps** persiguen crean puentes entre Desarrollo y Operaciones para dar respuestas a las interdependencias y resolver los problemas de integración.

Por la extensión del universo DevOps y por la carencia de conocimientos específicos para tratar el tema en profundidad, en este curso nos limitaremos a rascar la superficie y a exponer prácticas que ayudarán a mantener un flujo de desarrollo más continuo y confiable.


### Qué es Vagrant

**Vagrant** es una herramienta que permite configurar entornos de desarrollo mediante el control y provisionamiento de Máquinas virtuales.

El corazón de Vagrant es el `Vagrantfile`, archivo que define las propiedades de la máquina virtual (sistema operativo, IP pública o privada, métodos de provisionamiento y otros).

El siguiente es un ejemplo de Vagrantfile muy básico:

```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "hashicorp/precise64"

  config.vm.network :private_network, ip: "192.168.33.14"

  config.vm.hostname = "dev.my-project.com"

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", "2048"]
    vb.customize ["modifyvm", :id, "--cpus", 4]
  end

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "provisioning/playbook.yml"
    ansible.extra_vars = {private_interface: "192.168.100.1"}
  end

end
```

Una vez escrito el `Vagrantfile` y habiendo instalado Vagrant en nuestro equipo, cuando ejecutemos `vagrant up` se iniciará la descarga de la imagen virtual (`hashicorp/precise64`) para una máquina con 2048 MB de RAM y 4 núcleos. Una vez descargada se ejecutarán los mecanismos de provision establecidos en `config.vm.provision`. En este caso hemos escogido el provisionamiento con `ansible`, aunque la libertad de elección es amplia.

### Vagrant Boxes

El parámetro `config.vm.box` define la _box_ a utilizar. Una _box_ es una imagen ya creada de un entorno para la máquina virtual, y que servirá de base para nuestro provisionamiento específico. La web [Vagrant Cloud](https://vagrantcloud.com) dispone de un amplio y creciente catálogo de máquinas virtuales para escoger.

Las _boxes_ pueden ser instaladas localmente mediante el comando `vagrant box add`:


```bash
$ vagrant box add hashicorp/precise32
```

### Providers

Los providers permiten a Vagrant comunicarse con distintos gestores de máquina virtual. Los más comunes son `VirtualBox`, `VMware` o `Docker`.

### Provisioning

El provisioning consiste en la adecuación de la máquina virtual a las necesidades concretas del proyecto, incluyendo la creación de directorios, configuración de permisos, servidores web, librerías y cualquier otra operación automatizable.

Existen varias alternativas de provisioning. [Puphpet](https://puphpet.com/) es una aplicación web que ofrece un wizard para configurar un entorno y genera un Vagrantfile completo provisionando con `puppet`. 

[Ejemplo de provisioning con ansible](https://github.com/carlescliment/sample-vagrant-ansible)


### Comandos de Vagrant

Una vez terminados nuestros scripts de provisioning, levantaremos la máquina con `vagrant up`. El entorno se creará entonces de forma automática.

Con `vagrant ssh` accederemos a la máquina virtual con una conexión segura.

Para parar la máquina ejecutaremos `vagrant halt`, y para eliminarla definitivamente `vagrant destroy`.



## Integración Continua

Cuando un desarrollador aporta el código que ha desarrollado al flujo común de trabajo pueden surgir problemas de integración. Por ejemplo, pueden producirse conflictos en el repositorio o provocar una inestabilidad en el código de un tercero que dependía de una clase modificada por ellos.

La integración continua es un conjunto de _buenas prácticas_ que trata de combatir los problemas de integración integrando más a menudo.

### El repositorio

El repositorio de control de versiones permite mantener un historial actualizado y compartir código con comodidad. En ningún caso es un _vertedero para compartir código_. Debemos tratar el repositorio como si del código de producción se tratara, manteniéndolo en todo momento limpio y estable. Con Git y flujos de trabajo como Github, la buena salud del repositorio es aún más importante.

### Principios para el desarrollador

En el capítulo segundo del libro [Continuous Integration: Improving Software Quality and Reducing Risk](http://my.safaribooksonline.com/book/software-engineering-and-development/software-testing/9780321336385), sus autores enumeran siete buenas prácticas para los desarrolladores. Me he permitido reducirlas a las 5 que considero más importantes.

  * **Contribuye a menudo.** Si contribuyas tu código a menudo, en pequeñas porciones, reducirás el riesgo de colisiones con tus compañeros. Además, el equipo podrá utilizar las funcionalidades que hayas desarrollado tan pronto como las hayas contribuído.
  * **No contribuyas código roto.** Si contribuyes código roto estás poniendo en riesgo el trabajo de tus compañeros. Ellos utilizarán tu código suponiendo que es estable y, posiblemente, levanten código sobre él.
  * **Soluciona los builds rotos inmediatamente.** Por la razón comentada en el anterior punto, solucionar los problemas en el código del repositorio debe convertirse en la primera prioridad del equipo.
  * **Escribe tests automáticos.** La única manera de asegurar que un código es estable es cubriéndolo con tests. Un código sin tests se considera código inestable, por lo que todo commit al repositorio debería ir acompañado de sus tests correspondientes. Esto no será problemático si desarrollamos con TDD.
  * **Todos los tests deben pasar.** Aunque parezca algo elemental, algunas empresas permitían un margen de fallos en sus tests automáticos (por ejemplo, un 2%). Por todo lo comentado hasta ahora, si nos planteamos empezar a aplicar integración continua todos los tests automáticos deben pasar en todo momento.

### Tests continuos

Los desarrolladores deben ejecutar tests a medida que van desarrollando código. Normalmente es responsabilidad del desarrollador ejecutar constantemente los tests unitarios del código que está modificando. Además de estos tests y como hemos visto, existen otros tests de mayor nivel que aseguran la estabilidad del sistema. Como estos otros tests son bastante más lentos y ejecutar toda la batería de tests del proyecto podría resultar verdaderamente engorroso, la ejecución de los tests del build completo se deja en manos de servidores de integración continua.

Existen varios sistemas de integración continua disponibles en el mercado, como [Jenkins](http://jenkins-ci.org/) o [CruiseControl](http://cruisecontrol.sourceforge.net/). Estas aplicaciones pueden instalarse en máquinas dedicadas al control del código. Cuando un desarrollador contribuye código, el servidor de integración continua se pone en marcha para levantar el build y ejecutar el set de tests. En función de la configuración del sistema, el servidor puede rechazar el commit o enviar un aviso al equipo. Cuando los tests son demasiado pesados como para ser ejecutados en cada commit pueden seguirse otras estrategias como ejecutar los tests de manera periódica.

![Jenkins. Captura de pantalla](http://www.carlescliment.com/images/calidad_01_2012/jenkins.png)

Hay muchas maneras de avisar al equipo de un test fallido, desde las [lámparas de lava](http://blog.coryfoy.com/2008/10/build-status-lamp-with-ruby-and-teamcity/), los e-mails e incluso los [lanzamisiles](http://www.youtube.com/watch?v=1EGk2rvZe8A). Que cada equipo elija la que considere más apropiada.

### Staging

![Separación de entornos](http://www.carlescliment.com/images/calidad_01_2012/staging.png)

El staging consiste en la separación de entornos de trabajo. Permite aislar el entorno de desarrollo del de pruebas, y éste del de producción. Un flujo de staging habitual consiste en la separación de al menos los siguientes cuatro entornos: Desarrollo, Integración, Pre-producción y Producción.

El **entorno de desarrollo** es aquel en el que el desarrollador trabaja diariamente. El desarrollador hace un checkout del repositorio para trabajar en su máquina local y evitar conflictos con los desarrolladores. Si la aplicación necesita una base de datos, el desarrollador tendrá que configurarse un clon de la misma en su propia máquina. Es recomendable actualizar la copia de la base de datos a menudo.

El **entorno de integración** es el que utilizan todos los desarrolladores para integrar y probar el software en su conjunto. Como hemos comentado con anterioridad, al tratarse del espacio de trabajo común debe tenerse especial cuidado con mantenerlo limpio y estable.

El **entorno de preproducción** es un entorno aislado que se utiliza antes de los despliegues para realizar las pruebas finales. También puede servir para llevar a cabo las demos con cliente o testing con usuarios reales (beta-testing). Es importante que las características de configuración de este entorno, tanto en hardware como en software, sean tan parecidas como sea posible a las del entorno de producción. De este modo evitaremos problemas provocados por diferencias de versiones de software, hardwares incompatibles y problemas similares.

El **entorno de producción**, finalmente, es donde los clientes o usuarios dan uso a la aplicación. Puede ser un servidor web en el caso de sites online u ordenadores personales en aplicaciones comerciales.

Utilizar estos entornos de un modo ordenado nos permitirá desplegar siempre código estable y estar listos en todo momento para poder responder a necesidades del cliente. Además de entornos separados necesitaremos la ayuda del repositorio en forma de [branches](http://en.wikipedia.org/wiki/Branching_%28software%29).


### Automatización de procesos

La integración continua consiste en realizar los procesos cotidianos (como contribuir código, pasar tests o desplegar código) de forma constante, y para ello es recomendable introducir automatismos. La regla de oro es _"si lo vas a hacer dos veces, automatízalo"_. Seguramente termines haciéndolo muchas más. Así, los sistemas de integración continua no solo sirven para ejecutar tests y avisar a los desarrolladores en el caso de que el build se haya roto. También sirven para ejecutar todo tipo de scripts, como movimientos en ramas del repositorio, descargas de bases de datos o ejecución de analizadores de código.
