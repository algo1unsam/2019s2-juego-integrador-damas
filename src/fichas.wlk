import wollok.game.*
import tablero.*
import jugadores.*

class Ficha {
	var property position
	//var _esReina = false
	 	
	method move(nuevaPosicion) {
		if (self.puedoMoverme(nuevaPosicion) or self.puedoComer(nuevaPosicion)) {
			position = nuevaPosicion
			marcoSelector.soltaFicha()
			turnero.cambiaTurno()
		}
	}
	
	method puedoMoverme(posicion){
		return (posicion.x()==position.x()+1 or posicion.x()==position.x()-1) 
				and 
				(posicion.y()==position.y()+self.haciaDonde())
				and
				marcoSelector.estaVacio()	
	} 
	
	method puedoComer(posicion){
		
		//1) LA POSICIÓN DESTINO ESTÁ VACIA Y
		return marcoSelector.estaVacio()
		//2) ME MOVÍ DOS POSICIONES EN DIAGONAL Y
				and
				(posicion.x()==position.x()+2 or posicion.x()==position.x()-2) 
				and 
				(posicion.y()==position.y()+2*self.haciaDonde())
				and
		//3)LA POSICION ANTERIOR EN DIAGONAL TIENE FICHA DE CONTRINCANTE				
				(if(marcoSelector.masDerechaQueFichaSeleccionada())
					game.getObjectsIn(game.at(position.x()+1,position.y()+self.haciaDonde())).all({e=>not turnero.turnoDe().misFichas().contains(e)})
					and game.getObjectsIn(game.at(position.x()+1,position.y()+self.haciaDonde()))!=[]
				else
					game.getObjectsIn(game.at(position.x()-1,position.y()+self.haciaDonde())).all({e=>not turnero.turnoDe().misFichas().contains(e)})
					and game.getObjectsIn(game.at(position.x()-1,position.y()+self.haciaDonde()))!=[]
				)
				
		//=>PUEDO COMER
	}
	
	
	//METODOS SOBREESCRITOS EN CLASES HIJAS
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

