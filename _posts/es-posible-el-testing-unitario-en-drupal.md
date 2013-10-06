---
title: ¿Es posible el testing unitario en Drupal?
date: 2012-12-17
---

### Introducción

El sábado pasado se celebró en las oficinas de
[beCode](http://www.becodemyfriend.com/) un evento organizado por Juan Pablo
Novillo ([juampy](http://drupal.org/user/682736)) y Pedro Cambra
([pcambra](http://drupal.org/user/122101)). Se trataba de contribuir al
[proyecto devel](http://drupal.org/project/devel) y aligerar un poco la lista
de issues de este módulo de [Drupal](http://drupal.org/). A pesar de mi
relación de amor-odio con este gestor de contenidos (amor por la comunidad,
odio por la herramienta) me pareció atractiva la propuesta. No esperaba
conseguir commitear ningún parche, pero me servía volver a aproximarme a
Drupal después de un tiempo alejado, con una nueva perspectiva y tras 6 meses
de intenso aprendizaje. ¿Cómo abordaría hoy el desarrollo con Drupal?

### El fracaso

Con un poco de retraso y tras las presentaciones oportunas vía hangout, Juampy
y Pedro dieron comienzo al devel-contribute. Cada cual decidía en qué ponerse,
y tras olfatear el issue queue decidí invertir mi primera hora examinando el
código de Drush y del propio Devel. Tras unos vistazos rápidos saltaba a la
vista que había una gran issue pasada por alto; la urgente necesidad de
refactoring tanto de Drush como de Devel. Abrí el archivo devel.module y
escaneé rápidamente buscando código que necesitase una intervención urgente.
Me fijé en la función [_devel_print_object()](http://api.drupal.org/api/devel/
devel.module/function/_devel_print_object/7) y decidí empezar por ahí. La
función tiene de todo: * Un nombre poco preciso, ya que la función no
"imprime" variables, sino que les da formato en HTML. * Excesivo número de
parámetros, agravado por el uso de la recursividad (último parámetro) *
Excesivas responsabilidades. No sólo construye la representación sino que
también se encarga de identificar el tipo de objeto pasado y gestionar todo lo
necesario para la recursividad. Gestiona la adición opcional de un resumen.
Gestiona la adición o no de un prefijo. Aplica htmlspecialchars(), traduce,
etc... * Uso de variables estáticas. Una de ellas, por cierto, no se usa. *
Magic numbers (40) * ... Pero aparte de la baja calidad del código, había un
problema mucho mayor en el módulo devel. **Solo había un test case para todo
el módulo**. ¿Cómo iba a refactorizar una función si no había ningún test que
me protegiese?. Lo primero y necesario era construir un arnés de seguridad y
cubrir la [función "pública"](http://api.drupal.org/api/devel/devel.module/fun
ction/devel_print_object/7). Después ya vendrían los refactorings. Así que [me
devané los sesos](http://www.flickr.com/photos/juampy72/8274872934/in/photostr
eam/lightbox/) intentando testear la función unitariamente con PHPUnit y no
pude. Tenía varios problemas por en medio. Una llamada a [drupal_add_css()](ht
tp://api.drupal.org/api/drupal/includes!common.inc/function/drupal_add_css/7).
Otra a la función
[t()](http://api.drupal.org/api/drupal/includes!bootstrap.inc/function/t/7) y
a [format_plural()](http://api.drupal.org/api/drupal/includes!common.inc/funct
ion/format_plural/7), todas del core. Las de traducción, además, lanzan
queries a base de datos. Así que no lo podía testear. Intenté también tests de
integración con SimpleTest, pero cada testCase tarda algo así como medio
minuto y me iba a ser imposible completar los casos de prueba suficientes para
iniciar un refactoring con garantías. Se hizo la hora de comer y tiré la
toalla. Volví a casa. Me sentí bastante inútil por ser incapaz de escribir un
test sobre el código y despotriqué por twitter. Salí a pasear a los perros,
cené y... retomé el portátil.

### El primer test

Un poco más calmado y después de reflexionar un poco decidí hacer caso al
libro [Guide to build testable applications in PHP](https://leanpub.com
/grumpy-testing) y a una de las frases que anoté en mi disco duro: _"If you
can't test it, it is broken"_. Me animé a retomar el problema y escribí el
primer test.

    
    <?php
    
    require_once __DIR__ . '/../devel.module';
    
    class develPrintObjectTest extends PHPUnit_Framework_TestCase {
    
        /**
         * @test
         */
        public function itIsTestable() {
            // Arrange
            // Act
            devel_print_object(array());
    
            // Assert
            $this->assertTrue(true);
        }
    }
    

El test no hace nada, efectivamente, simplemente ejecuta la función. Pero me
serviría como guía para indicarme cuáles eran los problemas que tenía que
resolver antes de poder ejecutar el primer test "real". De manera que lancé el
test. ` PHP Fatal error: Call to undefined function drupal_add_css() in
/var/www/drupal/modules/devel/devel.module on line 1484 ` Ahí tenemos el
primer chivatazo. Una dependencia del módulo con una función del core que nos
obligará a levantar una parte del bootstrap de Drupal si no la conseguimos
romper. Para romper esta dependencia vamos a "inyectar" el core de Drupal en
la función de manera que podamos trabajar con ella desde el test. Aunque esto
implica añadir un parámetro más al populoso listado de parámetros, por ahora
nos es imprescindible. Cambiamos...

    
    <?php
    function devel_print_object($object, $prefix = NULL, $header = TRUE) {
      drupal_add_css(drupal_get_path('module', 'devel') . '/devel.css');
    ?>
    

...por...

    
    <?php
    function devel_print_object($object, $drupal_services, $prefix = NULL, $header = TRUE) {
      $css_file = $drupal_services->get('fileSystem')->getPath('module', 'devel') . '/devel.css';
      $drupal_services->get('frontEnd')->addCSS($css_file);
    ?>
    

Como véis también hemos eliminado una dependencia con la función
drupal_get_path(). Aunque aquella noche hice esto en dos pasos, aquí os lo
explico en uno para simplificar. $drupal_services será un wrapper sobre
funciones de Drupal. Un wrapper, por supuesto, que podremos falsear como
queramos. Escribimos el wrapper, que es muy sencillito e implementa el [patrón
factory](http://en.wikipedia.org/wiki/Factory_method_pattern):

    
    <?php
    class FileSystemService {
    
        public function getPath($type, $name) {
            return drupal_get_path($type, $name);
        }
    }
    
    class FrontEndService {
    
        public function addCSS($file) {
            return drupal_add_css($file);
        }
    }
    
    class DrupalServices {
        
        public function get($service) {
            switch ($service) {
                case 'fileSystem' :
                    return new FileSystemService;
                case 'frontEnd':
                    return new FrontEndService;
            }
        }
    }
    ?>
    

y en el test escribimos nuestro wrapper de mentira:

    
    <?php
    class FakeDrupalServices {
    
        private $testCase;
    
        public function __construct(PHPUnit_Framework_TestCase $testCase) {
            $this->testCase = $testCase;
        }
    
        public function get($service) {
            switch ($service) {
                case 'fileSystem' :
                    return $this->testCase->getMock('FileSystemService');
                case 'frontEnd':
                    return $this->testCase->getMock('FrontEndService');
            }
        }
    }
    
    
    class develPrintObjectTest extends PHPUnit_Framework_TestCase {
    
        /**
         * @test
         */
        public function itIsTestable() {
            // Arrange
            $fake_drupal_services = new FakeDrupalServices($this);
    
            // Act
            devel_print_object(array(), $fake_drupal_services);
    
            // Assert
            $this->assertTrue(true);
        }
    }
    ?>
    

El método get() de la clase FakeDrupalServices está devolviendo **stubs** de
los servicios (stubs, no mocks, no os confundáis porque se construyen con un
método getMock()). El stub nos sirve en este caso para que se puedan hacer
llamadas sobre él y no se rompa el flujo de ejecución. Al ejecutar el test nos
arroja otro error: ` PHP Fatal error: Call to undefined function t() in
/var/www/drupal/modules/devel/devel.module on line 1488 ` ¡Bien! Camuflando
las funciones nativas de Drupal en un wrapper hemos conseguido romper unas
pocas dependencias. Haremos lo mismo con la función t() escribiendo, en el
.module (en .module)

    
    <?php
    if ($header) {
        $output .= '<h3>' . $drupal_services->get('translator')->t('Display of !type !obj', array(
          '!type' => str_replace(array('$', '->'), '', $prefix),
          '!obj' => gettype($object),
        )
        ) . '</h3>';
      }
    
    // y más adelante...
    
              case 'boolean':
                $translator = $drupal_services->get('translator');
                $summary = $value ? $translator->t('TRUE') : $translator->t('FALSE');
                break;
    ?>
    

Tendremos que añadir la traducción a nuestro wrapper:

    
    <?php
    class TranslatorService {
    
        public function t($value, $parameters = array()) {
            return t($value, $parameters);
        }
    }
    
    // ...
    
    class DrupalServices {
    
        public function get($service) {
            switch ($service) {
                // ...
                case 'translator':
                    return new TranslatorService;
            }
        }
    }
    ?>
    

y completar el test

    
    <?php
    class FakeTranslator {
        public function t($value, $arguments) {
        $output = $value;
        if (isset($arguments['!type'])) {
            $output = str_replace('!type', $arguments['!type'], $output);
        }
        if (isset($arguments['!obj'])) {
            $output = str_replace('!obj', $arguments['!obj'], $output);
        }
        return $output;
        }
    }
    
    
    class FakeDrupalServices {
    
        // ...
        public function get($service) {
            switch ($service) {
                // ...        
                case 'translator':
                    return new FakeTranslator;
            }
        }
    }
    ?>
    

¿Veis que ahora, en el método get() de la clase FakeDrupalServices, devolvemos
un objeto FakeTranslator en lugar de un stub?. Esto es porque queremos
controlar el valor devuelto. Podríamos hacerlo con un stub si el valor de
respuesta fuera siempre el mismo, pero en este caso lo que vamos a hacer es
devolver la cadena recibida tal cual, pero reemplazando los símbolos. Así
obtendremos respuestas más comprensibles. Ejecutamos el test y... ` OK (1
test, 1 assertion) ` ¡Voilá! Ya hemos podido lanzar un test unitario sin que
la función llame directamente al core de Drupal. Mucho trabajo, ¿verdad?.
Además nos hemos arriesgado un poco cambiando las llamadas a funciones de
Drupal por llamadas al wrapper. ¡No teníamos más remedio!. Pero ahora ya
podemos empezar a escribir tests sobre la función que nos aseguren que, al
refactorizar, no nos estamos cargando nada. Además en el futuro podremos
reaprovechar todo este trabajo para romper otras dependencias con mayor
facilidad.

### Construyendo un arnés de tests

Después de hacer testable la función construímos un buen arnés para acometer
los cambios. Como veréis hemos suprimido el primer test (itIsTestable) porque
era un test de transición. En el camino nos saldrán otras dependencias de
format_plural() y drupal_strlen() que tendremos que romper.

    
    <?php
    
    require_once __DIR__ . '/../devel.module';
    require_once __DIR__ . '/../lib/DrupalServices.php';
    
    class FakeTranslator {
        public function t($value, $arguments = array()) {
            $output = $value;
            if (isset($arguments['!type'])) {
                $output = str_replace('!type', $arguments['!type'], $output);
            }
            if (isset($arguments['!obj'])) {
                $output = str_replace('!obj', $arguments['!obj'], $output);
            }
            return $output;
        }
    
        public function formatPlural($count, $singular, $plural) {
            if ($count == 1) {
                return $singular;
            }
            return str_replace('@count', $count, $plural);
        }
    
        public function strlen($value) {
            return strlen($value);
        }
    }
    
    class FakeDrupalServices {
    
        private $testCase;
    
        public function __construct(PHPUnit_Framework_TestCase $testCase) {
            $this->testCase = $testCase;
        }
    
        public function get($service) {
            switch ($service) {
                case 'fileSystem' :
                    return $this->testCase->getMock('FileSystemService');
                case 'frontEnd':
                    return $this->testCase->getMock('FrontEndService');
                case 'translator':
                    return new FakeTranslator;
            }
        }
    }
    
    
    class develPrintObjectTest extends PHPUnit_Framework_TestCase {
    
        private $fake_drupal_services;
    
        public function setUp() {
            $this->fake_drupal_services = new FakeDrupalServices($this);
        }
    
        /**
         * @test
         */
        public function itPrintsEmptyArrays() {
            // Arrange
            $expected_output = $this->head('array', '');
            $empty_array = array();
    
            // Act
            $output = devel_print_object($empty_array, $this->fake_drupal_services);
    
            // Assert
            $this->assertEquals($expected_output, $output);
        }
    
    
        /**
         * @test
         */
        public function itPrintsPlainUnkeyedArrays() {
            // Arrange
            $plain_unkeyed_array = array(
                1, 
                '', 
                'some longer string',
                'a really really really really loooooooooooong string. Yes it is, oooh, yes it is. Oh my daddy yes it is.',
                true
            );
            $expected_output = $this->head('array', 
                $this->renderField(1, 'string', '{empty}', '') . "\n" .
                $this->renderField(2,'string', $plain_unkeyed_array[2], $plain_unkeyed_array[2]) . "\n" .
                $this->renderField(3,'string', '104 characters', $plain_unkeyed_array[3]) . "\n" .
                $this->renderField(4,'boolean', 'TRUE', 'TRUE') . "\n"
            );
    
            // Act
            $output = devel_print_object($plain_unkeyed_array, $this->fake_drupal_services);
    
            // Assert
            $this->assertEquals($expected_output, $output);
        }
    
    
        /**
         * @test
         */
        public function itPrintsPlainKeyedArrays() {
            // Arrange
            $plain_keyed_array = array(
                'a' => 1, 
                1 => '', 
                'other_key' => 'some longer string',
                'b' => 'a really really really really loooooooooooong string. Yes it is, oooh, yes it is. Oh my daddy yes it is.',
                false => true
            );
            $expected_output = $this->head('array', 
                $this->renderField('a', 'integer', 1, 1) . "\n" .
                $this->renderField('1', 'string', '{empty}', $plain_keyed_array[1]) . "\n" .
                $this->renderField('other_key', 'string', $plain_keyed_array['other_key'], $plain_keyed_array['other_key']) . "\n" .
                $this->renderField('b', 'string', '104 characters', $plain_keyed_array['b']) . "\n"
            );
    
            // Act
            $output = devel_print_object($plain_keyed_array, $this->fake_drupal_services);
    
            // Assert
            $this->assertEquals($expected_output, $output);
        }
    
    
        /**
         * @test
         */
        public function itPrintsNestedArrays() {
            // Arrange
            $nested_array = array('some_key' => array('some_other_key' => array('last_key' => 'foo')));
            $expected_output = $this->head('array', '<span class="devel-attr"><dt><span class="field">some_key</span> (array, <em>1 element</em>)</dt>' . "\n" .
                '<dd>' . "\n" .
                'Array' . "\n" .
                '(' . "\n" .
                '    [some_other_key] =&gt; Array' . "\n" .
                '        (' . "\n" .
                '            [last_key] =&gt; foo' . "\n" .
                '        )' . "\n" .
                '' . "\n" .
                ')' . "\n" .
                '' . "\n" .
                '</dd></span>' . "\n");
    
            // Act
            $output = devel_print_object($nested_array, $this->fake_drupal_services);
    
            // Assert
            $this->assertEquals($expected_output, $output);
        }
    
        /**
         * @test
         */
        public function itPrintsEmptyObjects() {
            // Arrange
            $expected_output = $this->head('object', '');
            $empty_array = new stdClass();
    
            // Act
            $output = devel_print_object($empty_array, $this->fake_drupal_services);
    
            // Assert
            $this->assertEquals($expected_output, $output);
        }
    
        /**
         * @test
         */
        public function itPrintsPlainObjects() {
            // Arrange
            $plain_object = (object)array(
                'a' => 1, 
                'other_key' => 'some longer string',
                'b' => 'a really really really really loooooooooooong string. Yes it is, oooh, yes it is. Oh my daddy yes it is.',
            );
            $expected_output = $this->head('object', 
                $this->renderField('a', 'integer', 1, 1) . "\n" .
                $this->renderField('other_key', 'string', $plain_object->other_key, $plain_object->other_key) . "\n" .
                $this->renderField('b', 'string', '104 characters', $plain_object->b) . "\n"
            );
    
            // Act
            $output = devel_print_object($plain_object, $this->fake_drupal_services);
    
            // Assert
            $this->assertEquals($expected_output, $output);
        }
    
    
        /**
         * @test
         */
        public function itPrintsNestedObjectsWithArrays() {
            // Arrange
            $nested_object = (object) array('some_key' => array('some_other_key' => array('last_key' => 'foo')));
            $expected_output = $this->head('object', '<span class="devel-attr"><dt><span class="field">some_key</span> (array, <em>1 element</em>)</dt>' . "\n" .
                '<dd>' . "\n" .
                'Array' . "\n" .
                '(' . "\n" .
                '    [some_other_key] =&gt; Array' . "\n" .
                '        (' . "\n" .
                '            [last_key] =&gt; foo' . "\n" .
                '        )' . "\n" .
                '' . "\n" .
                ')' . "\n" .
                '' . "\n" .
                '</dd></span>' . "\n");
    
            // Act
            $output = devel_print_object($nested_object, $this->fake_drupal_services);
    
            // Assert
            $this->assertEquals($expected_output, $output);
        }
    
        /**
         * @test
         */
        public function itPrintsNestedObjectsWithOtherObjects() {
            // Arrange
            $nested_object = (object) array(
                'some_key' => (object)array(
                    'some_other_key' => (object) array(
                        'last_key' => 'foo'
                        )
                    )
                );
            $expected_output = $this->head('object', 
                $this->renderField('some_key', 'object', '1 element', 
                    $this->encapseContent($this->renderField('some_key->some_other_key', 'object', '1 element',
                        $this->encapseContent($this->renderField('some_key->some_other_key->last_key', 'string', 'foo', 'foo'))
                        )
                    )
                ) . "\n"
            );
    
            // Act
            $output = devel_print_object($nested_object, $this->fake_drupal_services);
    
            // Assert
            $this->assertEquals($expected_output, $output);
        }
    
    
        /**
         * @test
         */
        public function itOptionallyShowAPrefix() {
            // Arrange
            $empty_array = array();
            $prefix = "my_prefix";
            $expected_output = $this->head('array', '', $prefix);
    
            // Act
            $output = devel_print_object($empty_array, $this->fake_drupal_services, $prefix);
    
            // Assert
            $this->assertEquals($expected_output, $output);
        }
    
        /**
         * @test
         */
        public function itOptionallyShowAHeader() {
            // Arrange
            $empty_array = array();;
            $expected_output = $this->head('', '', '', false);
    
            // Act
            $output = devel_print_object($empty_array, $this->fake_drupal_services, null, false);
    
            // Assert
            $this->assertEquals($expected_output, $output);
        }
    
    
        private function renderField($key, $type, $representation, $actual_value) {
            return '<span class="devel-attr"><dt><span class="field">' . $key . 
                   '</span> ('. $type . ', <em>' . $representation . '</em>)</dt>' . "\n" .
                   '<dd>' . "\n" .
                   $actual_value . "\n" .
                   '</dd></span>' ;
        }
    
        private function head($type, $content, $prefix = '', $header = true) {
            $output = '<div class="devel-obj-output">';
            if ($header) {
                $output .= '<h3>Display of ' . $prefix . ' ' . $type . "</h3>";
            }
            $output .= "<dl>\n" . $content . "</dl>\n</div>";
            return $output;
        }
    
    
        private function encapseContent($content) {
            return '<dl>' . "\n" . $content ."\n</dl>";
        }
    }
    

Después de un rato de testing obtenemos esta bonita imagen:
![](https://pbs.twimg.com/media/A-MbprMCcAEtVS7.png:large)

### Refactorizando

La función no era sencilla de refactorizar. Empecé identificando bloques de
código que parecían constituir unidades propias y extrayéndolas a funciones
separadas. Eliminé el magic number definiendo una constante. Cambié el nombre
_devel_print_object() por _devel_render_object(), aunque tampoco me satisfizo
el cambio. Eliminé varios if/elseif/else utilizando returns para romper la
ejecución. Después de unos cuantos pequeños refactorings pensé que ya era
suficiente. En realidad, llegado a este punto, el ejercicio había perdido todo
mi interés. Mi objetivo no era refactorizar la función, sino **demostrar que
el testing unitario en Drupal es posible** eliminando las dependencias del
módulo con el core. Si hubiese seguido refactorizando, creo que al final
habría empezado de cero y, mediante TDD, intentar solucionar el problema de
otro modo. La recursividad de esa función y los distintos flags opcionales la
hace un galimatías muy difícil de modificar. Empiezo a estar muy acostumbrado
a la orientación a objetos y me resulta muy incómodo el enfoque procedural.
Desde luego intentaría separar la inyección de código HTML del algoritmo
recursivo, y aplicar este renderizado más adelante. Imagino que terminaría
haciendo un árbol con objetos que otra entidad supiese renderizar en función
del estado (arrays, booleanos, padres, hijos...). De todos modos os pongo aquí
el código resultante por si queréis echarle un ojo:

    
    <?php
    /**
     * Displays an object or array.
     *
     * @param array|object $object
     *   The object or array to display.
     * @param string $prefix
     *   Prefix for the output items (example "$node->", "$user->", "$").
     * @param boolean $header
     *   Set to FALSE to suppress the output of the h3 tag.
     */
    function devel_print_object($object, $drupal_services, $prefix = NULL, $header = TRUE) {
      $css_file = $drupal_services->get('fileSystem')->getPath('module', 'devel') . '/devel.css';
      $drupal_services->get('frontEnd')->addCSS($css_file);
      $output = '<div class="devel-obj-output">';
      if ($header) {
        $output .= _devel_render_header($object, $prefix, $drupal_services->get('translator'));
      }
      $output .= _devel_render_object($object, $drupal_services, $prefix);
      $output .= '</div>';
      return $output;
    }
    
    
    function _devel_render_header($object, $prefix, $translator) {
        return '<h3>' . $translator->t('Display of !type !obj', array(
          '!type' => str_replace(array('$', '->'), '', $prefix),
          '!obj' => gettype($object),
        )
        ) . '</h3>';
        
    }
    
    /**
     * Returns formatted listing for an array or object.
     *
     * Recursive (and therefore magical) function goes through an array or object
     * and returns a nicely formatted listing of its contents.
     *
     * @param array|object $obj
     *   Array or object to recurse through.
     * @param object $drupal_services
     *   Wrapper to break dependencies with core functions.
     * @param string $prefix
     *   Prefix for the output items (example "$node->", "$user->", "$").
     * @param string $parents
     *   Used by recursion.
     * @param boolean $object
     *   Used by recursion.
     *
     * @return string
     *   Formatted html.
     *
     * @todo
     *   currently there are problems sending an array with a varname
     */
    function _devel_render_object($obj, $drupal_services, $prefix = NULL, $parents = NULL, $object = FALSE) {
      static $root_type;
    
      // TODO: support objects with references. See http://drupal.org/node/234581.
      if (isset($obj->view)) {
        return;
      }
    
      if (!isset($root_type)) {
        $root_type = gettype($obj);
        if ($root_type == 'object') {
          $object = TRUE;
        }
      }
      return _devel_render($obj, $drupal_services, $prefix, $parents, $object);
    }
    
    
    
    
    function _devel_render($obj, $drupal_services, $prefix, $parents, $object) {
      $output = '';
      if (is_object($obj)) {
        $obj = (array) $obj;
      }
      if (is_array($obj)) {
        $output =_devel_render_array($obj, $drupal_services, $prefix, $parents, $object);
      }
      return $output;    
    }
    
    
    
    
    function _devel_render_array($obj, $drupal_services, $prefix, $parents, $object) {
        $output = "<dl>\n";
        foreach ($obj as $field => $value) {
          if ($field == 'devel_flag_reference') {
            continue;
          }
          if (!is_null($parents)) {
            $field = _devel_get_child_field($parents, $field, $object);
          }
    
          $type = gettype($value);
    
          $show_summary = TRUE;
          $summary = NULL;
          if ($show_summary) {
            $summary = _devel_summarize($type, $value, $drupal_services->get('translator'));
          }
          $typesum = _devel_add_type_to_summary($type, $summary);
          $value = _devel_check_for_references($value, $drupal_services, $prefix, $field);
          $output .= _devel_render_value($value, $prefix, $field, $typesum);
        }
        $output .= "</dl>\n";
        return $output;
    }
    
    
    function _devel_get_child_field($parents, $field, $object) {
        if ($object) {
          return $parents . '->' . $field;
        }
        if (is_int($field)) {
          return $parents . '[' . $field . ']';
        }
        return $parents . '[\'' . $field . '\']';
    }
    
    
    function _devel_summarize($type, $value, $translator) {
        switch ($type) {
          case 'string':
          case 'float':
          case 'integer':
            return _devel_summarize_basic_type($value, $translator);
          case 'array':
          case 'object':
            return _devel_summarize_array((array)$value, $translator);
    
          case 'boolean':
            return _devel_summarize_boolean($value, $translator);
        }
    
    }
    
    
    function _devel_summarize_basic_type($value, $translator) {
        if (strlen($value) == 0) {
          return $translator->t("{empty}");
        }
        if (strlen($value) < DEVEL_MIN_LENGTH_TO_ABBREVIATE_VAR) {
          return htmlspecialchars($value);
        }
        return $translator->formatPlural($translator->strlen($value), '1 character', '@count characters');
    }
    
    
    function _devel_summarize_array($value, $translator) {
        return $translator->formatPlural(count((array) $value), '1 element', '@count elements');
    }
    
    function _devel_summarize_boolean($value, $translator) {
        return $value ? $translator->t('TRUE') : $translator->t('FALSE');
    }
    
    
    function _devel_add_type_to_summary($type, $summary) {
      if (!is_null($summary)) {
        return '(' . $type . ', <em>' . $summary . '</em>)';
      }
      return '(' . $type . ')';
    }
    
    
    function _devel_check_for_references(&$value, $drupal_services, $prefix, $field) {
      if (is_array($value) && isset($value['devel_flag_reference'])) {
        $value['devel_flag_reference'] = TRUE;
      }
      if (is_array($value) && isset($value['devel_flag_reference']) && !$value['devel_flag_reference']) {
        $value['devel_flag_reference'] = FALSE;
        return _devel_render_object($value, $drupal_services, $prefix, $field);
      }
      if (is_object($value)) {
        $value->devel_flag_reference = FALSE;
        return _devel_render_object((array) $value, $drupal_services, $prefix, $field, TRUE);
      }
      $value = is_bool($value) ? ($value ? 'TRUE' : 'FALSE') : $value;
      return htmlspecialchars(print_r($value, TRUE)) . "\n";
    }
    
    
    function _devel_render_value($value, $prefix, $field, $typesum) {
      $output = '<span class="devel-attr">';
      $output .= "<dt><span class=\"field\">{$prefix}{$field}</span> $typesum</dt>\n";
      $output .= "<dd>\n";
      // Check for references to prevent errors from recursions.
      $output .= $value;
      $output .= "</dd></span>\n";
      return $output;
    }
    ?>
    

### Conclusiones

Aunque hayamos desmenuzado una función monstruosa en otras muy pequeñas, este
código me sigue pareciendo horroroso. El paso de parámetros de un sitio a
otro, acentuado por la necesidad de inyectar un wrapper adicional, la ya
varias veces comentada recursividad, el enfoque procedural, etc... hacen que
este código necesite en realidad un diseño desde cero. Pero como os digo más
arriba, el objetivo era otro. En este post se demuestra que **se puede hacer
testing unitario en Drupal** si antes nos construímos las herramientas
necesarias, y por lo tanto se hace posible el desarrollo de TDD. Una función
será la encargada de proporcionar los servicios reales de Drupal, y no los
inyectados por nosotros, pero podemos intentar que esta construcción se
realice en los niveles más altos de ejecución (una función submit, por
ejemplo). Lo ideal sería que Drupal dispusiera de un [contenedor de inyección
de dependencias](http://martinfowler.com/articles/injection.html) y fuese él
mismo el encargado de proporcionar estas dependencias a un módulo para que no
se las tengamos que pasar nosotros como parámetros de función. El enfoque
procedural complica estas cosas, claro. Sin duda con orientación a objetos
todo sería más fácil.

    
    <?php
    
    /**
     * Abstract class module.
     */
    abstract class Module {
    
      private $core;
    
      public function __construct(DrupalCore $core) {
        $this->core = $core;
      }
    
      protected function getDrupalCore() {
        return $this->core;
      }
    
    }
    
    
    
    /**
     * A concrete module
     */
    class DevelModule extends Module {
    
      public function printObject($object) {
        $css_file = $this->getDrupalCore()->getModulePath('devel') . '/custom.css';
        $this->getDrupalCore()->getService('theming')->addCSS($css_file);
        // ...
      }
    
      // many other methods.
    
    }
    
    
    
    
    /**
     * The Drupal core
     */
    class DrupalCore {
    
      /**
       * Builds modules and passes to them a reference to itself.
       */
      public function loadModules() {
        // ...
        foreach($modulesToEnable as $module_class) {
          $this->enableModule(new $module_class($this));
        }
        // ...
      }
    
    }
    ?>
    

