--- layout: default title: Instalar Sonar en proyectos PHP created: 1323379654 --- 

_Nota: este artículo fue revisado el día 19 de Julio de 2013 para corregir
algunas indicaciones que habían quedado obsoletas. No dudéis en contactar
conmigo a través de este blog ante cualquier inconveniencia durante la
instalación y configuración de Sonar._

## ¿Qué es Sonar?

[Sonar](http://www.sonarsource.org/) es una aplicación que permite analizar
distintos parámetros de calidad del software en proyectos informáticos. Con un
sistema flexible y adaptable a las necesidades del proyecto, permite controlar
varios aspectos del software como la [complejidad
ciclomática](http://en.wikipedia.org/wiki/Cyclomatic_complexity), el grado de
[replicación de código](http://en.wikipedia.org/wiki/Don%27t_repeat_yourself),
la cobertura con tests o el respeto por los [coding
standards](http://en.wikipedia.org/wiki/Coding_standards).

Manteniendo estos parámetros bajo control con esta herramienta **gratuita**
conseguiremos un diagnóstico constante del estado de salud de nuestro código,
lo que permitirá añadir funcionalidades sobre el mismo de un modo más rápido y
por tanto más económico.

&nbsp_place_holder;

## Instalar Sonar

Sigue las instrucciones de la [documentación del paquete](http://sonar-
pkg.sourceforge.net/) en función de tu distribución.

Iniciaremos el servicio con

`$ sudo service sonar start`

Podremos acceder a la aplicación desde un navegador en la ruta

`localhost:9000` -> cambiad localhost por la ip o nombre de máquina si estáis
instalando Sonar en otro servidor.

&nbsp_place_holder;

## Configurar Sonar para proyectos PHP con Ant

A continuación debemos iniciar sesión en Sonar (admin/admin son el usuario y
password por defecto) e instalar el plugin PHP. Para ello, una vez iniciada la
sesión iremos a la sección de **Administración** -> **Update Center** ->
**Available plugins** y selecionarremos el plugin **PHP**. Será necesario
reiniciar Sonar.

Siguiendo los pasos de [Codehaus](http://docs.codehaus.org/display/SONAR/Insta
lling+and+Configuring+SonarQube+Ant+Task) descargaremos Sonar Ant Task en el
directorio de nuestra elección y crearemos un enlace simbólico en el
directorio lib/ de nuestra instalación de Ant (en mi caso /usr/share/ant/lib).

[![](/sites/default/files/sonar_ant_task.png)](/sites/default/files/sonar_ant_
task.png)

&nbsp_place_holder;

## Definir nuestras propias reglas

De nuevo en la interfaz de administración de Sonar, acudiremos a "Quality
Profiles" para crear un perfil PHP propio. El mío está creado a partir del ya
existente "All PHPMD Rules" y pinta tal que así.

[![](/sites/default/files/php_profile.png)](/sites/default/files/php_profile.p
ng)

Haciendo click en cada una de las reglas podremos personalizar el grado de
exigencia que le queremos otorgar así como su "severidad". Podemos añadir
tantas reglas como queramos y definir nuestras propias alertas.

Bien, ahora hay que construir el script Ant que nos servirá para darle a Sonar
información sobre nuestro proyecto. Este script, que podemos colocar allí
donde queramos, debe llamarse build.xml. Yo centralizo todas estas cosas en mi
directorio de integración continua /var/ci, pero es una cuestión de gusto
personal. Este es el aspecto de mi build.xml.

    
    <project name="Orchards">
    
      <property name="src.dir" value="/var/www/vhosts/orchards/trunk" />
      <property name="test.dir" value="/var/www/vhosts/orchards/trunk/tests" />
      <property name="build.dir" value="/var/ci/sonar/orchards" />
      <property name="classes.dir" value="${build.dir}/classes" />
      <property name="reports.dir" value="${build.dir}/reports" />
      <property name="reports.junit.xml.dir" value="${reports.dir}/junit" />
    
    
       <!-- list of properties (optional) -->
       <property name="sonar.projectName" value="Orchards" />
       <property name="sonar.projectKey" value="orchards" />
       <property name="sonar.projectVersion" value="orchards" />
       <property name="sonar.dynamicAnalysis" value="false" />
       <property name="sonar.language" value="php" />
       <property name="sonar.sources" value="/var/www/vhosts/orchards/trunk" />
    
    
      <!-- Define the Sonar task -->
      <taskdef uri="antlib:org.sonar.ant" resource="org/sonar/ant/antlib.xml">
        <classpath path="/usr/share/ant/lib" />
      </taskdef>
    
      <!-- Add the target -->
      <target name="sonar">
        <sonar:sonar xmlns:sonar="antlib:org.sonar.ant">
    
        </sonar:sonar>
      </target>
    </project>
    

Lo único que tenéis que hacer es cambiar las distintas rutas a las de vuestros
directorios de trabajo de sonar y vuestro código fuente y tests phpUnit. Ahora
hay que dejar que ant haga su trabajo: ` `

`$ant sonar `

[![](/sites/default/files/ant_executed.png)](/sites/default/files/ant_executed
.png)

Acabamos de dar a Sonar la información que necesitaba sobre nuestro proyecto.
Si volvemos a la home de nuestra interfaz Sonar, veremos que aparece una fila
con nuestro proyecto. Haciendo click en él, encontraremos una vista parecida a
la siguiente:

[![](/sites/default/files/Sonar%20Dashboard.png)](/sites/default/files/Sonar%2
0Dashboard.png)

Explorad un poco la interfaz y disfrutad de la información que se despliega
ante vosotros.

&nbsp_place_holder;

&nbsp_place_holder;

## PHPUnit con Sonar

El plugin PHP ya nos proporciona la posibilidad de utilizar PHPUnit en
nuestros proyectos, entre otras herramientas.

En primer lugar modificaremos el archivo build.xml añadiendo las siguientes
líneas:

    
    
    <!-- Testing-->
       <property name="sonar.dynamicAnalysis" value="true" />
       <property name="sonar.phpUnit.skip" value="false" />
       <property name="sonar.phpUnit.analyze.test.directory" value="true" />
       <property name="sonar.phpUnit.configuration" value="/var/www/vhosts/orchards/trunk/tests/phpunit.xml" />
    

El siguiente es un ejemplo sencillo del archivo `phpunit.xml` referenciado en
la configuración anterior:

    
    
    <testsuites>
      <testsuite name="unitary">
        <directory>/var/www/vhosts/orchards/trunk/tests</directory>
      </testsuite>
    </testsuites>
    

Solo falta ejecutar de nuevo el comando _$ ant sonar_ y podremos ver una
imagen como esta:

[![](/sites/default/files/sonar_phpunit.png)](/sites/default/files/sonar_phpun
it.png)

¡Hay que mejorar esa cobertura!

&nbsp_place_holder;

## Analizar un proyecto Drupal

Para analizar un proyecto Drupal basta con cambiar la ruta del código fuente a
nuestra instalación Drupal. Lo ideal es analizar exclusivamente los módulos
que producimos y que deberían estar en un directorio aparte en
sites/all/modules/ para evitar el ruído producido por módulos contribuídos (a
no ser que estemos pensando en refactorizarlos ;)). Además, habrá que decirle
a sonar que analice archivos con extensiones .module. Podemos hacerlo
iniciando sesión y haciendo click en los "Settings" de nuestro proyecto.

&nbsp_place_holder;

## Conclusiones

Bien, pues ya tenemos nuestra herramienta de análisis de código instalada en
nuestro equipo. Ahora toca explorar y aprender todas las posibilidades que
Sonar nos ofrece para tener toda la información sobre el código que producimos
a nuestro alcance.

Espero que os sea de utilidad y no dudéis en transmitirme cualquier duda o
corregirme en este post.

Un saludo!

