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
	
	//JUGADOR INDICA QUE YA MOVIÓ
	method yaMovi(){
		turnero.cambiaTurno(self)
	}
	
	//SE ELIMINA LA FICHA QUE SE PASA POR ARGUMENTO
	method quitarFicha(ficha){
		fichasRestantes.remove(ficha)
		
	}
	
}

object jugador1 inherits Jugador{
	var property unidades
	var property decenas
	var property estado=1
	var imagenes=["jugador1.png","jugador1EnTurno.png"]
	
	
	var property position = game.at(1, 6)

	method image() {
		return imagenes.get(estado)
	}
	
	override method nombre(){
		return "Jugador 1"
	}
 
}

object jugador2 inherits Jugador{
	var property unidades
	var property decenas
	var property estado=0
	var imagenes=["jugador2.png","jugador2EnTurno.png"]	
	
	var property position = game.at(1, 3)

	method image() {
		return imagenes.get(estado)
	}
	
	override method nombre(){
		return "Jugador 2"
	}
}