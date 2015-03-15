---
title: Setters y getters
date: 2012-07-13
---

Desde que he empezado a trabajar con Symfony 2 me ha llamado la atención el
uso de setters y getters. A juzgar por el código que he podido leer, y con el
generado por el scaffolding cuando hacemos, por ejemplo, `app/console
generate:doctrine:entity`, existe una convención según la cual todos los
atributos de una clase son privados y vienen acompañados de sus dos accesores,
aunque estos no hagan validación o modificación alguna de los datos de
entrada. El resultado para una clase con bastantes atributos es el siguiente:

```
<?php

/**
 * @ORM\Entity
 * @ORM\Table(name="customers", uniqueConstraints={@ORM\UniqueConstraint(name="customer_idcard", columns={"id_card"})}))
 */
class Customer {

    /**
     * @ORM\Id
     * @ORM\Column(type="integer", unique=true)
     * @ORM\GeneratedValue(strategy="AUTO")
     */

    private $id;

    /**
     * @ORM\Column(type="string",length=255)
     */
    private $name;

    /**
     * @ORM\Column(type="string", length=255)
     */
    private $surname;

    /**
    * @ORM\Column(type="string", length=512)
    */
    private $address = '';

    /**
     * @ORM\Column(type="string", length=255)
     */
    private $city = '';

    /**
     * @ORM\Column(type="string", length=5)
     */
    private $postal_code = '';

    /**
     * @ORM\Column(type="string", length=255)
     */
    private $telephone = '';

    /**
     * @ORM\Column(type="string", length=255)
     */
    private $mobile = '';

    /**
    * @ORM\Column(type="string", length=255)
    */
    private $id_card = '';

    /**
     * @ORM\Column(type="string", length=255)
     */
    private $email = '';


    public function getId() {
        return $this->id;
    }

    public function setId($id) {
        $this->id = $id;
    }

    public function getName() {
        return $this->name;
    }

    public function setName($name) {
        $this->name = $name;
    }

    public function getSurname() {
        return $this->surname;
    }

    public function setSurname($surname) {
        $this->surname = $surname;
    }

    public function getAddress() {
        return $this->address;
    }

    public function setAddress($address) {
        $this->address = $address;
    }

    public function getCity() {
        return $this->city;
    }

    public function setCity($city) {
        $this->city = $city;
    }

    public function getPostalCode() {
        return $this->postal_code;
    }

    public function setPostalCode($postal_code) {
        $this->postal_code = $postal_code;
    }

    public function getTelephone() {
        return $this->telephone;
    }

    public function setTelephone($telephone) {
        $this->telephone = $telephone;
    }

    public function getMobile() {
        return $this->mobile;
    }

    public function setMobile($mobile) {
        $this->mobile = $mobile;
    }

    public function getIdCard() {
        return $this->id_card;
    }

    public function setIdCard($id_card) {
        $this->id_card = $id_card;
    }

    public function getEmail() {
        return $this->email;
    }

    public function setEmail($email) {
        $this->email = $email;
    }
}
```
Cuando planteé esta cuestión a veteranos de Symfony, aunque no había una
postura clara, la mayoría apuntaba a la necesidad de encapsular los datos
impidiendo que clientes de la clase modificasen sus atributos directamente. El
argumento no me pareció convincente pues, ¿qué diferencia hay entre asignar un
valor a un atributo público y setearlo a través de un método? En la mayoría de
los casos, los setters y getters no hacen nada más que establecer o devolver
el valor del atributo, sin procesarlo. Probablemente el efecto en el
rendimiento no es perceptible, pero la legibildad cuenta.

Otro posible argumento es establecer una interfaz para que las clases que
implementen herencia puedan añadir validaciones y procesamiento sobre los
datos, si lo necesitan. Un argumento con algo más de peso pero que tampoco me
parece resolutivo. Y es que, en mi opinión, lo que tenemos delante es una
malinterpretación del encapsulamiento.

Encapsular es separar la interfaz que proporcionan nuestras clases de la
implementación de las mismas. Hay un artículo muy interesante de _The
Pragmatic Bookshelf_ titulado [Tell, don't ask](http://pragprog.com/articles
/tell-dont-ask), que habla de esta separación entre la interfaz y el estado.
Incorporando setters y getters estamos exponiendo la implementación de nuestra
clase (su estado), y esto no es encapsular sino todo lo contrario.

Ocurre que en Symfony, normalmente, nos servimos de ORMs como Doctrine y
pasamos sus instancias a plantillas Twigg, y estas a su vez acceden a los
atributos de las entidades. Twigg es lo suficientemente listo como para buscar
un accesor de un atributo cuando éste es privado, por lo que `customer.name` tendrá el mismo efecto sea el atributo público o privado. Esta práctica
tendrá sus fans y detractores. Algunos te dirán que nadie debería preguntar a
"customer" sobre su nombre, que si lo que se quiere es representar un objeto
customer, este debería proporcionar un método `$customer->render()` y saber él
solito representarse - o mejor aún, una clase renderizadora -. Lo cierto es
que el uso de un ORM y plantillas es bastante cómodo, de modo que prefiero
centrarme en este caso.

Desde luego, viendo cómo accedemos a los atributos de una instancia en una
plantilla, es evidente que no estamos ocultando su implementación. Las
plantillas necesitan saber todos y cada uno de los atributos que han de
representar, cosa que no creo que sea mala 'per se'. Lo que está mal es fingir
que estamos encapsulando con setters y getters indiscriminados.

Uno de los asistentes a la primera reunión de Symfony en Valencia dijo algo
muy acertado. La lógica de negocio no debería estar en las clases del ORM,
sino en otras que colaboren que estas. Las entidades del ORM se convierten
entonces en simples colecciones, en 'transportes' de datos, algo así como los
[DTOs](http://martinfowler.com/eaaCatalog/dataTransferObject.html). Un DTO es
puro estado, no muy diferente de un array, a pesar de que esté implementado
como una clase. Siendo puro estado, la necesidad de encapsular (separar la
interfaz del estado) desaparece.

Las entidades del ORM deberían ser una colección de atributos públicos, y la
lógica de negocio debería llevarse a otro lado. Todo sería mucho más claro.

```
<?php
/**
* @ORM\Entity
* @ORM\Table(name="customers", uniqueConstraints={@ORM\UniqueConstraint(name="customer_idcard", columns={"id_card"})}))
*/
class Customer {

    /**
     * @ORM\Id
     * @ORM\Column(type="integer", unique=true)
     * @ORM\GeneratedValue(strategy="AUTO")
     */
    public $id;

    /**
     * @ORM\Column(type="string", length=255)
     */
    public $name;

    /**
     * @ORM\Column(type="string",length=255)
     */
    public $surname;

    /**
     * @ORM\Column(type="string", length=512)
     */
    public $address = '';

    /**
     * @ORM\Column(type="string", length=255)
     */
    public $city = '';

    /**
     * @ORM\Column(type="string", length=5)
     */
    public $postal_code = '';

    /**
     * @ORM\Column(type="string", length=255)
     */
    public $telephone = '';

    /**
     * @ORM\Column(type="string", length=255)
     */
    public $mobile = '';

    /**
     * @ORM\Column(type="string", length=255)
     */
    public $id_card = '';

    /**
     * @ORM\Column(type="string", length=255)
     */
    public $email = '';

}
```
______________________________________________________________________________
UPDATE 25 de octubre de 2012: La
[documentación de Doctrine](http://docs.doctrine-project.org/projects/doctrine-orm/en/latest/tutorials/getting-started.html#a-first-prototype)
especifica lo siguiente:

_Properties should never be public when using Doctrine. This will
lead to bugs with the way lazy loading works in Doctrine._

¡Pues ya tenemos una razón para el uso de setters y getters! Al menos cuando existan relaciones
entre clases. Información proporcionada por [Fran
Moreno](https://twitter.com/franmomu) y [Vicente
Monsonís](https://twitter.com/vicentemonsonis). ¡Gracias!

