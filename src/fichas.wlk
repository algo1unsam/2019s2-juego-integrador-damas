import wollok.game.*
import tablero.*
import jugadores.*

class Ficha {
	var property position
	//var _esReina = false
	
	method diagonalDerecha(){
		return game.at(position.x()+1,position.y()+self.haciaDonde())
	}
	
	method diagonalIzquierda(){
		return game.at(position.x()-1,position.y()+self.haciaDonde())
	}
		 	
	method validar(nuevaPosicion) {
		if(self.puedoMoverme(nuevaPosicion)) {
			self.soloMovete(nuevaPosicion)			
		}
		if(self.puedoComer(nuevaPosicion)){
			self.come(nuevaPosicion, self.tengoParaComer())
		}
	}
	
	//SE MUEVE UNA POSICIÓN QUE LE LLEGA DEL MARCO SELECTOR
	method soloMovete(nuevaPosicion){
		position = nuevaPosicion
		self.terminarMovimiento()
	}
	
	//COME FICHA CONTRINCANTE
	method come(nuevaPosicion, ficha){
		//tablero.quitarFicha(ficha) NO FUNCIONA
		turnero.contrincante().quitarFicha(ficha)
		position = nuevaPosicion
		self.terminarMovimiento()
	}
	
	//VALIDA SI TIENE PARA COMER
	method tengoParaComer(){
				
		if(marcoSelector.masDerechaQueFichaSeleccionada()){
			if(tablero.loQueHayEn(self.diagonalDerecha())!=null and tablero.loQueHayEn(self.diagonalDerecha()).all({e=>not self.pertenezcoA().misFichas().contains(e)})){
				return tablero.loQueHayEn(self.diagonalDerecha())
			}
		}
		else{			
			if(tablero.loQueHayEn(self.diagonalIzquierda())!=null and tablero.loQueHayEn(self.diagonalIzquierda()).all({e=>not self.pertenezcoA().misFichas().contains(e)})){
				return tablero.loQueHayEn(self.diagonalIzquierda())
			}
		}
		
		return null	
	}

	//SE VALIDA MOVIMIENTO EN DIAGONAL SIMPLE
	method puedoMoverme(posicion){
		return (posicion.equals(self.diagonalDerecha()) or posicion.equals(self.diagonalIzquierda()))		
				and marcoSelector.estaVacio()
	} 
	
	//FICHA LE INDICA A SELECTOR QUE LA SUELTE Y JUGADOR DICE QUE YA MOVIÓ
	method terminarMovimiento(){
		marcoSelector.soltaFicha()
		self.pertenezcoA().yaMovi()
	}
	
	//SE VALIDA SI LA FICHA PUEDE COMER
	method puedoComer(posicion){
		
		//1) LA POSICIÓN DESTINO ESTÁ VACIA Y
		return marcoSelector.estaVacio()
		//2) ME MOVÍ DOS POSICIONES EN DIAGONAL Y
				and
				(posicion.x()==position.x()+2 or posicion.x()==position.x()-2) 
				and 
				(posicion.y()==position.y()+2*self.haciaDonde())
				and
		//3)LA POSICION EN DIAGONAL TIENE FICHA DE CONTRINCANTE				
				self.tengoParaComer()!=null
				
		//=>PUEDE COMER
	}
			
	//METODOS SOBREESCRITOS EN CLASES HIJAS
	method haciaDonde()
	method image()
	method pertenezcoA()

}

class FichaClara inherits Ficha {
	
	override method haciaDonde(){
		return 1
	} 
	
	override method image(){
		return "fichaClara.png"
	}
	
	override method pertenezcoA(){
		return jugador1
	}
	
}

class FichaOscura inherits Ficha {
	
	override method haciaDonde(){
		return -1
	}
	
	override method image(){
		return "fichaOscura.png"
	}
	
	override method pertenezcoA(){
		return jugador2
	}
		
}

