import wollok.game.*
import tablero.*
import jugadores.*

class Ficha {
	var property position
	var queDiagonal=null
	//var _esReina = false
	
	method diagonalDerecha(){
		return game.at(position.x()+1,position.y()+self.haciaDonde())
	}
	
	method diagonalIzquierda(){
		return game.at(position.x()-1,position.y()+self.haciaDonde())
	}
		 	
	method validar(nuevaPosicion) {
		if(self.puedoMoverme(nuevaPosicion)) {
			self.movete(nuevaPosicion)			
		}
		if(self.puedoComer(nuevaPosicion)){
			self.come(nuevaPosicion, tablero.loQueHayEn(queDiagonal))
		}
	}
	
	//SE MUEVE UNA POSICIÓN QUE LE LLEGA DEL MARCO SELECTOR
	method movete(nuevaPosicion){
		position = nuevaPosicion
		self.terminarMovimiento()
	}
	
	//COME FICHA CONTRINCANTE Y LUEGO SE MUEVE
	method come(nuevaPosicion, ficha){
		ficha.forEach{e=>tablero.quitarFicha(e)}
		ficha.forEach{e=>turnero.contrincante().quitarFicha(e)}
		self.movete(nuevaPosicion)
	}
	
	//VALIDA SI TIENE PARA COMER
	method tengoParaComer(){
				
		if(marcoSelector.masDerechaQueFichaSeleccionada()){
			queDiagonal=self.diagonalDerecha()
		}else{			
			queDiagonal=self.diagonalIzquierda()
		}
		
		return tablero.loQueHayEn(queDiagonal)!=null and tablero.loQueHayEn(queDiagonal).all({e=>not self.pertenezcoA().misFichas().contains(e)})	
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
				self.tengoParaComer()
				
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

