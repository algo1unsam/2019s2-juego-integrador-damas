import wollok.game.*
import fichas.*
import jugadores.*

object tablero {

	var property position = game.at(4, 0)

	method image() {
		return "tablero.jpg"
	}
 
}

object marcoSelector {

	var property position = game.at(4, 2)
	var property fichaSeleccionada=null

	method tomaFicha(posicion) {
		game.colliders(self).forEach{ ficha =>
			if (ficha != (self) and turnero.turnoDe().misFichas().contains(ficha)) {
				fichaSeleccionada = ficha
			}
		}
	}

	method moveFicha(posicion) {
		fichaSeleccionada.move(posicion)
		
	}
	
	method soltaFicha(){
		fichaSeleccionada = null
	}

	method movete(nuevaPosicion) {
		position = nuevaPosicion
		if (position.x() > 11) {
			position = game.at(11, position.y())
		}
		if (position.x() < 4) {
			position = game.at(4, position.y())
		}
		if (position.y() > 7) {
			position = game.at(position.x(), 7)
		}
		if (position.y() < 0) {
			position = game.at(position.x(), 0)
		}
	}

	method image() {
		return "marco.png"
	}
	
	method estaVacio(){
		return game.colliders(self).all{elemento => elemento == self}
	}
	
	method masDerechaQueFichaSeleccionada(){
		return position.x() - fichaSeleccionada.position().x() > 0
	}

}

object turnero {

	var jugadorEnTurno = jugador1
	//SET DE JUGADORES
	const jugadores = [jugador1,jugador2]
	
	
	method turnoDe() {
		return jugadorEnTurno
	}
	
	method cambiaTurno(jugador){
		jugadorEnTurno = jugadores.find({e=>e!=jugador})
		game.say(marcoSelector, "Turno de: " + jugadorEnTurno.nombre())
		
		var cuantasFichas = jugadorEnTurno.misFichas().size()
		var decena = cuantasFichas / 10
		var unidad = cuantasFichas % (10)
		jugadorEnTurno.decenas().asignarNumero(decena.truncate(0))
		jugadorEnTurno.unidades().asignarNumero(unidad)
		
	}

}

class Marcador {

	var listaDeNumeros = [ "numCero.jpg", "numUno.jpg", "numDos.jpg", "numTres.jpg", "numCuatro.jpg", "numCinco.jpg", "numSeis.jpg", "numSiete.jpg", "numOcho.jpg", "numNueve.jpg" ]
	var numero = 0

	method listaDeNumeros() {
		return listaDeNumeros
	}

	method asignarNumero(nuevoNumero) {
		numero = nuevoNumero
		self.image()
	}

	method image() {
		return self.listaDeNumeros().get(numero)
	}

}

object claraDec inherits Marcador {

	var property position = game.at(1, 5)

}

object claraUni inherits Marcador {

	var property position = game.at(2, 5)

}

object oscuraDec inherits Marcador {

	var property position = game.at(1, 2)

}

object oscuraUni inherits Marcador {

	var property position = game.at(2, 2)

}

