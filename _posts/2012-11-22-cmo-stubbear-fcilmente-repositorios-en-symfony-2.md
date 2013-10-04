--- layout: default title: !binary |- Q8OzbW8gc3R1YmJlYXIgLSBmw6FjaWxtZW50ZSAtIHJlcG9zaXRvcmlvcyBl biBTeW1mb255IDI= created: 1353599158 --- Stubbear repositorios puede ser un quebradero de cabeza en Symfony 2. Os pongo un ejemplo: 
    
    <?php
    class MySampleTest extends \PHPUnit_Framework_TestCase {
    
        public function testChainedStub() {
            // Arrange
            $em = $this->getMock('EntityManager', array('getConnection');
            $expectedResults = array('foo', 'bar', 'baz');
            $get_connection_mock = $this->getMock('Doctrine\ORM\EntityManager', array('executeQuery'), array(), '', false);
            $em->expects($this->at(0))
                ->method('getConnection')
                ->will($this->returnValue($get_connection_mock));
            $execute_query_mock = $this->getMock('Doctrine\ORM\EntityManager', array('fetchAll'), array(), '', false);
            $get_connection_mock->expects($this->at(0))
                ->method('executeQuery')
                ->will($this->returnValue($execute_query_mock));
            $execute_query_mock->expects($this->at(0))
                ->method('fetchAll')
                ->will($this->returnValue($expectedResults));
    
            // Act
            $results = $em->getConnection()->executeQuery()->fetchAll();
    
            // Assert
            $this->assertEquals($expectedResults, $results);
        }
    }
    ?>
    

Este código permite simular una resupuesta para una llamada como
$em->getConnection()->exeuteQuery('...')->fetchAll(); ¡Muy complicado! Para
simplificar las cosas he desarrollado [un pequeño bundle que permite stubbear
llamadas encadenadas](https://github.com/carlescliment/BladeTester/tree/master
/ChainedStubsBundle). Es tan fácil como:

    
    <?php
    class MySampleTest extends \PHPUnit_Framework_TestCase {
    
        public function testChainedStub() {
            // Arrange
            $em = $this->getMock('EntityManager', array('getConnection');
            $expectedResults = array('foo', 'bar', 'baz');
            $stubChainer = new StubChainer($this);
            $stubChainer->chain($em, array('getConnection', 'executeQuery', 'fetchAll'), $expectedResults);
    
            // Act
            $results = $em->getConnection()->executeQuery()->fetchAll();
    
            // Assert
            $this->assertEquals($expectedResults, $results);
        }
    }
    ?>
    

Ahora ya podemos testear fácilmente repositorios o cualquier otra clase que
permita encadenar llamadas. ¡Espero que os sea tan útil como a mí!

