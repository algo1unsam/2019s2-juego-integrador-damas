import wollok.game.*
import tablero.*
import jugadores.*

class Ficha {
	var property position
	//var _esReina = false
	 	
	method move(nuevaPosicion) {
		if(self.puedoMoverme(nuevaPosicion)){
			position = nuevaPosicion
			turnero.cambiaTurno()
			
		}
	}
	
	method puedoMoverme(posicion){
		return (posicion.x()==position.x()+1 or 
				posicion.x()==position.x()-1) 
				and 
				(posicion.y()==position.y()+1*self.haciaDonde())
	} 
	
	method haciaDonde()
	

}

class FichaClara inherits Ficha {
	override method haciaDonde(){
		return 1
	} 
	
	method image(){return "fichaClara.png"}

}

class FichaOscura inherits Ficha {
	override method haciaDonde(){
		return -1
	}
	
	method image(){return "fichaOscura.png"}

}

