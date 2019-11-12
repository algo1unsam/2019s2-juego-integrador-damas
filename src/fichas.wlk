import wollok.game.*
import tablero.*
import jugadores.*

class Ficha {
	
	var property position
	var tipo = damaComun
	var property estado=enBlanco
	var property comerEnCadena=false
	var property queDiagonal=null	
		
	//VARIABLES PARA LA REINA: CADA LISTA CONTIENE LAS COORDENADAS 
	//RESPECTO DE LA POSICION REINA
	var property diagArribaDerecha = []
	var property diagArribaIzquierda = []
	var property diagAbajoDerecha = []
	var property diagAbajoIzquierda = []

		 	
	method validar(nuevaPosicion) {
		tipo.validar(nuevaPosicion, self)
	}
	
	//Define de que lado tiene para comer
	method enDondetengoParaComer(){			
		if(marcoSelector.masDerechaQueFichaSeleccionada()){
			queDiagonal=self.diagonalDerecha()
		}else{			
			queDiagonal=self.diagonalIzquierda()
		}	
	}
	
	//COME FICHA CONTRINCANTE Y LUEGO SE MUEVE
	method come(nuevaPosicion, ficha){
		tipo.come(nuevaPosicion, ficha)
		self.movete(nuevaPosicion)
		comerEnCadena=true
	}
	
	//SE VALIDA MOVIMIENTO
	method puedoMoverme(nuevaPosicion){
		return tipo.puedoMoverme(nuevaPosicion, self)
	}
			
	//Metodos soporte para validar el movimiento simple 
	method diagonalDerecha(){
		return game.at(position.x()+1,position.y()+self.haciaDonde())
	}
	
	method diagonalIzquierda(){
		return game.at(position.x()-1,position.y()+self.haciaDonde())
	}
	
	//SE VALIDA SI LA FICHA PUEDE COMER 
	method puedoComer(posicion){
		return tipo.puedoComer(posicion, self)				
	}
			 
	//SE MUEVE UNA POSICIÓN QUE LE LLEGA DEL MARCO SELECTOR
	method movete(nuevaPosicion){
		
		if(tipo.equals(damaComun) and self.meTransformoEnReina(nuevaPosicion)){
			self.transformarAReina()
		}
		tipo.movete(nuevaPosicion, self)
	}
	
	method transformarAReina(){
		//CAMBIAR SU IMAGEN
		tipo = damaReina
	}
		
	//FICHA LE INDICA A SELECTOR QUE LA SUELTE Y JUGADOR DICE QUE YA MOVIÓ
	method terminarMovimiento(){
			marcoSelector.soltaFicha()
			self.pertenezcoA().yaMovi()
			self.comerEnCadena(false)			
	}
	
	method superaLoslimtes(posicion){
		return posicion.x()>tablero.topeDer() 
				or posicion.x()<tablero.topeIzq() 
				or posicion.y()>tablero.topeSup() 
				or posicion.y()<tablero.topeInf()
	}
	
	//METODOS SOBREESCRITOS EN CLASES HIJAS
	method haciaDonde()
	method image()
	method pertenezcoA()
	method meTransformoEnReina(destino)
}

class FichaClara inherits Ficha {
	var imagenes = ["fichaClara.png", "fichaClaraSeleccionada.png"]
	
	override method haciaDonde(){
		return 1
	}
	
	override method image() {
		return imagenes.get(estado.devolvePosicion())
	}
	
	override method pertenezcoA(){
		return jugador1
	}
	
	override method meTransformoEnReina(destino){
		return destino.y().equals(tablero.topeSup())
	}
	
}

class FichaOscura inherits Ficha {
	var imagenes = ["fichaOscura.png", "fichaSeleccionada.png"]
		
	override method haciaDonde(){
		return -1
	}
	
	override method image() {
		return imagenes.get(estado.devolvePosicion())
	}
	
	override method pertenezcoA(){
		return jugador2
	}
	
	override method meTransformoEnReina(destino){
		return destino.y().equals(tablero.topeInf())
	}
}

object damaComun{
	
	method validar(nuevaPosicion, fichaEnUso){
		//verifica si puede hacer un movimiento siemple, el not comerEnCadena 
		//es para evitar que luego de comer haga un movimiento simple
		if(fichaEnUso.puedoMoverme(nuevaPosicion) and not fichaEnUso.comerEnCadena()) {
			fichaEnUso.movete(nuevaPosicion)
			fichaEnUso.terminarMovimiento()
		//Verifica si puede comer y que la posicion a la que se mueva 
		//sea +-2 horizontales y +o-verticales	
		}else 
			if(fichaEnUso.puedoComer(fichaEnUso.position()) and (nuevaPosicion.x()-fichaEnUso.position().x()).abs()==2 and (nuevaPosicion.y()-fichaEnUso.position().y()).abs()==2){
				fichaEnUso.enDondetengoParaComer()
				//define de que lado puede comer y tira erro si 
				//pudiendo comer de un lado trata de mover al otro 
				if((self.esPosibleComerDerecha(fichaEnUso.position(),fichaEnUso) and fichaEnUso.queDiagonal()==fichaEnUso.diagonalDerecha())
				or(self.esPosibleComerIzquierda(fichaEnUso.position(),fichaEnUso) and fichaEnUso.queDiagonal()==fichaEnUso.diagonalIzquierda())
			){
				fichaEnUso.come(nuevaPosicion, tablero.loQueHayEn(fichaEnUso.queDiagonal()))
			}else{
				marcoSelector.error("Ese movimiento no es válido")
			}
		}else{
			marcoSelector.error("Ese movimiento no es válido")
		}
	}
	
	method puedoComer(posicion, fichaEnUso){
		return self.esPosibleComerDerecha(posicion,fichaEnUso) or self.esPosibleComerIzquierda(posicion,fichaEnUso)
	}
	
	method come(nuevaPosicion, ficha){
		tablero.quitarFicha(ficha)
		turnero.contrincante().quitarFicha(ficha)
	}
	
	method puedoMoverme(posicion, ficha){
		return (posicion.equals(ficha.diagonalDerecha()) or posicion.equals(ficha.diagonalIzquierda())) and marcoSelector.estaVacio()
	}
	
	method movete(destino, ficha){
		ficha.position(destino)
	}
	
	
	method esPosibleComerDerecha(posicion, fichaEnUso){
	 
	  		return(
	 			turnero.contrincante().misFichas().any{ficha=>ficha.position()==fichaEnUso.diagonalDerecha()}
	 			and
	  			turnero.contrincante().misFichas().all{ficha=>ficha.position()!=game.at(posicion.x()+2,posicion.y()+fichaEnUso.haciaDonde()*2)}
	  			and
	 			fichaEnUso.pertenezcoA().misFichas().all{ficha=>ficha.position()!=game.at(posicion.x()+2,posicion.y()+fichaEnUso.haciaDonde()*2)}
	 			and not
	 			fichaEnUso.superaLoslimtes(game.at(posicion.x()+2,posicion.y()+fichaEnUso.haciaDonde()*2))
	 		)
	 }
	 
	 //Metodo para verificar si puede comer a la izquierda
	 method esPosibleComerIzquierda(posicion, fichaEnUso){
	 
	  		return(
	 			turnero.contrincante().misFichas().any{ficha=>ficha.position()==fichaEnUso.diagonalIzquierda()}
	 			and
	  			turnero.contrincante().misFichas().all{ficha=>ficha.position()!=game.at(posicion.x()-2,posicion.y()+fichaEnUso.haciaDonde()*2)}
	  			and
	 			fichaEnUso.pertenezcoA().misFichas().all{ficha=>ficha.position()!=game.at(posicion.x()-2,posicion.y()+fichaEnUso.haciaDonde()*2)}
		 		and not
	 			fichaEnUso.superaLoslimtes(game.at(posicion.x()-2,posicion.y()+fichaEnUso.haciaDonde()*2)) 			
	 		)
	 }
			
}

object damaReina{
	
	const property imagen = ""
	
	method validar(nuevaPosicion, fichaEnUso){
		
		if(fichaEnUso.puedoMoverme(nuevaPosicion) and not fichaEnUso.comerEnCadena()) {
			fichaEnUso.movete(nuevaPosicion)
			fichaEnUso.terminarMovimiento()
		}
		if(fichaEnUso.puedoComer(nuevaPosicion)){
			
		}
	}
		
	method puedoComer(posicion, ficha){
		return marcoSelector.estaVacio() and self.hayParaComer(posicion, ficha)
	}
	
//	method come(posicion, ficha){
//		tablero.quitarFicha(ficha)
//		turnero.contrincante().quitarFicha(ficha)
//	}
	
	method puedoMoverme(destino, ficha){
		//1) ESTA VACÍA LA POSICION DESTINO
		//2) Y LAS CELDAS DE LA DIAGONAL ESTÁN TODAS VACIAS
		return marcoSelector.estaVacio() and self.estaVacio(destino,ficha)
	}
	
	method movete(destino, ficha){
		
			ficha.position(destino)
			self.vaciarListasDeCoordenadas(ficha) 	//LAS COORDENADAS ANTERIORES
			tablero.asignarCoordenadas()		//USO LAS COORDENADAS DE LA FICHA COMO REFERENCIA
			tablero.invocador(0)				//LE ASIGNA LAS COORDENADAS A LAS LISTAS
			
	}
	
	//RETORNA LOS ELEMENTOS DE LA DIAGONAL ENTRE LA FICHA Y EL DESTINO
	method diagonal(destino, ficha){
		
		if(marcoSelector.masDerechaQueFichaSeleccionada()){
			//A LA DERECHA
			if(marcoSelector.masArribaQueFichaSeleccionada()){
				//ARRIBA
				return ficha.diagArribaDerecha().filter{c=>c.y()<destino.y()}.map{c=>game.getObjectsIn(c)}
			}else{
				//ABAJO
				return ficha.diagAbajoDerecha().filter{c=>c.y()>destino.y()}.map{c=>game.getObjectsIn(c)}	
			}
		}else{
			//A LA IZQUIERDA
			if(marcoSelector.masArribaQueFichaSeleccionada()){
				//ARRIBA
				return ficha.diagArribaIzquierda().filter{c=>c.y()<destino.y()}.map{c=>game.getObjectsIn(c)}	
			}else{
				//ABAJO
				return ficha.diagAbajoIzquierda().filter{c=>c.y()>destino.y()}.map{c=>game.getObjectsIn(c)}	
			}
		}
	}
	
	method estaVacio(destino, ficha){
		return self.diagonal(destino, ficha).flatten().isEmpty()
	}
	
	method hayParaComer(destino, ficha){
		return self.diagonal(destino, ficha).uniqueElement().pertenezcoA()!=ficha.pertenezcoA()
	}
	
	method vaciarListasDeCoordenadas(ficha){
		ficha.diagArribaDerecha().clear()
		ficha.diagArribaIzquierda().clear()
		ficha.diagAbajoDerecha().clear()
		ficha.diagAbajoIzquierda().clear()
	}
	
}