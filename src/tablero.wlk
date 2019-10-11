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
	var property fichaSeleccionada

	method tomaFicha(posicion) {
		game.colliders(self).forEach{ ficha =>
			if (ficha != (self) and turnero.turnoDe().misFichas().contains(ficha)) {
				fichaSeleccionada = ficha
			}
		}
	}

	method moveFicha(posicion) {
		fichaSeleccionada.move(posicion)
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

}

object turnero {

	var jugadorEnTurno = jugador1

	method turnoDe() {
		return jugadorEnTurno
	}

	method cambiaTurno() {
		if (jugadorEnTurno.equals(jugador1)) {
			jugadorEnTurno = jugador2
			game.say(marcoSelector, "Turno jugador 2")
		} else {
			jugadorEnTurno = jugador1
			game.say(marcoSelector, "Turno jugador 1")
		}
		//El marcador cambia al comenzar el turno de cada jugador (así actualiza si hubo alguna ficha comida en el turno anterior)
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

	var position = game.at(1, 5)

}

object claraUni inherits Marcador {

	var position = game.at(2, 5)

}

object oscuraDec inherits Marcador {

	var position = game.at(1, 2)

}

object oscuraUni inherits Marcador {

	var position = game.at(2, 2)

}
