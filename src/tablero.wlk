import wollok.game.*
import fichas.*
import jugadores.*


object tablero{
	var property position=game.at(4,0)
	
	method image(){return "tablero.jpg"}	
}

object marcoSelector {
	
	var property position=game.at(4,2)
	var property fichaSeleccionada
		
	method tomaFicha(posicion){
		game.colliders(self).forEach{ficha=>if(ficha!=(self) and turnero.turnoDe().misFichas().contains(ficha)){fichaSeleccionada=ficha}}
	}
	
	method moveFicha(posicion){
		fichaSeleccionada.move(posicion)
		fichaSeleccionada = null
	}
	
	method movete(nuevaPosicion) {
		
		position = nuevaPosicion
		
		if(position.x()>11){
			position = game.at(11,position.y())
		}
		if(position.x()<4){
			position = game.at(4,position.y())
		}
		if(position.y()>7){
			position = game.at(position.x(),7)
		}
		if(position.y()<0){
			position = game.at(position.x(),0)
		}
	} 
	
	method image(){return "marco.png"}	

}

object turnero{
	var jugadorEnTurno = jugador1
	
	method turnoDe(){
		return jugadorEnTurno
	}
	
	method cambiaTurno(){
		if(jugadorEnTurno.equals(jugador1)){
			jugadorEnTurno = jugador2
			game.say(marcoSelector, "Turno jugador 2")
		}else{
			jugadorEnTurno = jugador1
			game.say(marcoSelector, "Turno jugador 1")
		}
	}
	
	}

