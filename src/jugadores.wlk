import wollok.game.*
import tablero.*
import fichas.*

class Jugador{
	const fichas = []
	const fichasRestantes = []
	var property nombre //no usado todavia
	
	method misFichas(){
		return fichasRestantes
	}
	
	method agregarFichas(ficha){
		fichas.addAll(ficha)
		fichasRestantes.addAll(ficha)
	}
	
	method yaMovi(){
		turnero.cambiaTurno(self)
	}
	
}

object jugador1 inherits Jugador{
	var property unidades=claraUni
	var property decenas=claraDec
	
	
	var property position = game.at(1, 6)

	method image() {
		return "jugador1.jpg"
	}
	
	override method nombre(){
		return "Jugador 1"
	}
 
}

object jugador2 inherits Jugador{
	var property unidades=oscuraUni
	var property decenas=oscuraDec
	
	
	var property position = game.at(1, 3)

	method image() {
		return "jugador2.jpg"
	}
	
	override method nombre(){
		return "Jugador 2"
	}
}