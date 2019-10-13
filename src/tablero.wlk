import wollok.game.*
import fichas.*
import jugadores.*

object tablero {

	var property position = game.at(4, 0)

	method image() {
		return "tablero.jpg"
	}
	
	method loQueHayEn(posicion){
		if(game.getObjectsIn(posicion)!=[])
			return game.getObjectsIn(posicion)
		else
			return null			
	}
	
	method quitarFicha(ficha){
		game.removeVisual(ficha)
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
	//EL SELECTOR PRUEBA MOVER FICHA
	method moveFicha(posicion) {
		fichaSeleccionada.validar(posicion)
	}
	
	//EL SELECTOR SUELTA LA FICHA
	method soltaFicha(){
		fichaSeleccionada = null
	}
	
	//MUEVE EL MARCO SELECTOR
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
		
		jugadorEnTurno.estado(1)
		jugadorEnTurno.image()
		self.contrincante().estado(0)
		self.contrincante().image()		
	}
	//RETORNA AL JUGADOR QUE ESTÁ ESPERANDO EL MOVIMIENTO
	method contrincante(){
		return jugadores.find({jugador=>not jugador.equals(jugadorEnTurno)})
	}

}

class Marcador {
	var listaDeNumeros = [ "numCero.png", "numUno.png", "numDos.png", "numTres.png", "numCuatro.png", "numCinco.png", "numSeis.png", "numSiete.png", "numOcho.png", "numNueve.png" ]
	var numero

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


