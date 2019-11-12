import wollok.game.*
import tablero.*
import jugadores.*

class Ficha {
	var property position
	var property queDiagonal=null
	//variable para que cambie de color cuando se selecciona la ficha
	var property estado=enBlanco
	//Variable que marca si ya comió alguna ficha
	var property comerEnCadena=false
		
	//VARIABLES PARA LA REINA
	var tipo = damaComun
	
	//VARIABLES PARA LA REINA: CADA LISTA CONTIENE LAS COORDENADAS 
	//RESPECTO DE LA POSICION REINA
	var property diagArribaDerecha = []
	var property diagArribaIzquierda = []
	var property diagAbajoDerecha = []
	var property diagAbajoIzquierda = []

		 	
	method validar(nuevaPosicion) {
		//verifica si puede hacer un movimiento siemple, el not comerEnCadena es para evitar que luego de comer haga un movimiento simple
		if(self.puedoMoverme(nuevaPosicion) and not comerEnCadena) {
			self.movete(nuevaPosicion)
			self.terminarMovimiento()
		//Verifica si puede comer y que la posicion a la que se mueva sea +-2 horizontales y +o-verticales	
		}else if(self.puedoComer(position) and (nuevaPosicion.x()-position.x()).abs()==2 and (nuevaPosicion.y()-position.y()).abs()==2){
			self.enDondetengoParaComer()
			//define de que lado puede comer y tira erro si pudiendo comer de un lado trata de mover al otro 
			if((self.esPosibleComerDerecha(position) and queDiagonal==self.diagonalDerecha())or(self.esPosibleComerIzquierda(position) and queDiagonal==self.diagonalIzquierda())){
				self.come(nuevaPosicion, tablero.loQueHayEn(queDiagonal))
			}else{
				marcoSelector.error("Ese movimiento no es válido")
			}
		}else{
			marcoSelector.error("Ese movimiento no es válido")
		}
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
		ficha.forEach{e=>tablero.quitarFicha(e)}
		ficha.forEach{e=>turnero.contrincante().quitarFicha(e)}
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
		return	tipo.puedoComer(posicion, self)				
	}
	
	method superaLoslimtes(posicion){
		return posicion.x()>11 or posicion.x()<4 or posicion.y()>7 or posicion.y()<0
	}
	
	//Metodo para verificar si puede comer a la derecha
	method esPosibleComerDerecha(posicion){
	 
	  		return(
	 			turnero.contrincante().misFichas().any{ficha=>ficha.position()==self.diagonalDerecha()}
	 			and
	  			turnero.contrincante().misFichas().all{ficha=>ficha.position()!=game.at(posicion.x()+2,posicion.y()+self.haciaDonde()*2)}
	  			and
	 			self.pertenezcoA().misFichas().all{ficha=>ficha.position()!=game.at(posicion.x()+2,posicion.y()+self.haciaDonde()*2)}
	 			and not
	 			self.superaLoslimtes(game.at(posicion.x()+2,posicion.y()+self.haciaDonde()*2))
	 		)
	 }
	 
	 //Metodo para verificar si puede comer a la izquierda
	 method esPosibleComerIzquierda(posicion){
	 
	  		return(
	 			turnero.contrincante().misFichas().any{ficha=>ficha.position()==self.diagonalIzquierda()}
	 			and
	  			turnero.contrincante().misFichas().all{ficha=>ficha.position()!=game.at(posicion.x()-2,posicion.y()+self.haciaDonde()*2)}
	  			and
	 			self.pertenezcoA().misFichas().all{ficha=>ficha.position()!=game.at(posicion.x()-2,posicion.y()+self.haciaDonde()*2)}
		 		and not
	 			self.superaLoslimtes(game.at(posicion.x()-2,posicion.y()+self.haciaDonde()*2)) 			
	 		)
	 }
	  
	//SE MUEVE UNA POSICIÓN QUE LE LLEGA DEL MARCO SELECTOR
	method movete(nuevaPosicion){
		
		if(self.meTransformoEnReina(nuevaPosicion)){
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

	
	method vaciarListasDeCoordenadas(){
		diagArribaDerecha.clear()
		diagArribaIzquierda.clear()
		diagAbajoDerecha.clear()
		diagAbajoIzquierda.clear()
	}
				
	//METODOS SOBREESCRITOS EN CLASES HIJAS
	method haciaDonde()
	method image()
	method pertenezcoA()
	method meTransformoEnReina(destino)
}

class FichaClara inherits Ficha {
	var imagenes = ["fichaClara.png", "fichaSeleccionada.png"]
	
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
	
	method puedoComer(posicion, ficha){
		return ficha.esPosibleComerDerecha(posicion) or ficha.esPosibleComerIzquierda(posicion)
	}
	
	method puedoMoverme(posicion, ficha){
		return (posicion.equals(ficha.diagonalDerecha()) or posicion.equals(ficha.diagonalIzquierda())) and marcoSelector.estaVacio()
	}
	
	method movete(destino, ficha){
		ficha.position(destino)
	}
			
}

object damaReina{
	
	method puedoComer(posicion, ficha){
	}
	
	method puedoMoverme(destino, ficha){
		//1) ESTA VACÍA LA POSICION DESTINO
		//2) Y LAS CELDAS DE LA DIAGONAL ESTÁN TODAS VACIAS
		return marcoSelector.estaVacio() and self.estaVacio(destino,ficha)
	}
	
	method movete(destino, ficha){
		
			ficha.position(destino)
			ficha.vaciarListasDeCoordenadas() 	//LAS COORDENADAS ANTERIORES
			tablero.asignarCoordenadas()		//USO LAS COORDENADAS DE LA FICHA COMO REFERENCIA
			tablero.invocador(0)				//LE ASIGNA LAS COORDENADAS A LAS LISTAS
			ficha.terminarMovimiento()
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
		return self.diagonal(destino, ficha).flatten().size().equals(0)
	}
	
}