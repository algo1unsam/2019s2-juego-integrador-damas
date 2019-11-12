import wollok.game.*
import tablero.*
import jugadores.*

class Ficha {
	var property position
	//variable para que cambie de color cuando se selecciona la ficha
	var property estado=enBlanco
	//Variables para ir aumentando la posición en caso de poder comer en cadena
	var comidasSeguidasHorizontal=0
	var comidasSeguidasVertical=0	
	//Lista de fichas a comer sea una sola o varias si come en cadena
	var property fichasAComer=[]
		
	//VARIABLES PARA LA REINA
	var tipo = damaComun
	
	//VARIABLES PARA LA REINA: CADA LISTA CONTIENE LAS COORDENADAS 
	//RESPECTO DE LA POSICION REINA
	var property diagArribaDerecha = []
	var property diagArribaIzquierda = []
	var property diagAbajoDerecha = []
	var property diagAbajoIzquierda = []

		 	
	method validar(nuevaPosicion) {
		if(self.puedoMoverme(nuevaPosicion)) {
			self.movete(nuevaPosicion)			
		}else if(self.puedoComer(position)){
			self.comerEncadenado()
		}else{
			marcoSelector.error("Ese movimiento no es válido")
		}
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
	
	method laPosicion(){
		return game.at(position.x()+comidasSeguidasHorizontal,position.y()+comidasSeguidasVertical*self.haciaDonde())
	}

	method comerEncadenado(){
		var fichas=[]
		
		//Verifica si puede comer
		if(self.puedoComer(self.laPosicion())){
			//Verifica si puede comer a la izquierda y a la derecha, o en una de ellas
			if(self.esPosibleComerDerecha(self.laPosicion()) and self.esPosibleComerDerecha(self.laPosicion())){
				if (marcoSelector.masDerechaQueFichaSeleccionada()){
					//guarda la ficha en la lista provisoria
					fichas=tablero.loQueHayEn(game.at(self.laPosicion().x()+1,self.laPosicion().y()+1*self.haciaDonde()))
					//aumenta posicion horizontal
					comidasSeguidasHorizontal=2+comidasSeguidasHorizontal					
				}else{
					fichas=tablero.loQueHayEn(game.at(self.laPosicion().x()-1,self.laPosicion().y()+1*self.haciaDonde()))
					comidasSeguidasHorizontal=comidasSeguidasHorizontal-2					
				}
			}else if(self.esPosibleComerDerecha(self.laPosicion())){
				//guarda la ficha en la lista provisoria
				fichas=tablero.loQueHayEn(game.at(self.laPosicion().x()+1,self.laPosicion().y()+1*self.haciaDonde()))
				//aumenta posicion horizontal
				comidasSeguidasHorizontal=2+comidasSeguidasHorizontal
			}else{
				fichas=tablero.loQueHayEn(game.at(self.laPosicion().x()-1,self.laPosicion().y()+1*self.haciaDonde()))
				comidasSeguidasHorizontal=comidasSeguidasHorizontal-2
			}
			//aumenta posicion en vertical
			comidasSeguidasVertical=comidasSeguidasVertical+2
			//carga la ficha en la lista acumulatoria
			fichas.forEach{ficha=>self.fichasAComer().add(ficha)}
			
			//Verifica si la posicion coincide con el marcoSelector, si no es así verifica si se salió de los límites o si puede seguir comiendo
			if(self.laPosicion()==marcoSelector.position()){
				//Si es igual al marcoSelector come la/s ficha/s, mueve y vuelve a o los valores de movimiento
				self.fichasAComer().forEach{ficha=>tablero.quitarFicha(ficha); turnero.contrincante().quitarFicha(ficha)}
				self.movete(self.laPosicion())
				self.limpiarFichasAComer()	
			}else if(self.laPosicion().x()>11 or self.laPosicion().x()<4 or self.laPosicion().y()>7 or self.laPosicion().y()<0){
				//Si salió de los límites sin tener la misma posicion que el marcoSelector da invalido el movimiento
				self.limpiarFichasAComer()	
				game.say(marcoSelector,"Movimiento Invalido")
			}else{
				//Si no pasa lo anterior verifica si puede seguir comiendo		
				self.comerEncadenado()
			}
		}else{
				self.limpiarFichasAComer()		
				game.say(marcoSelector,"Movimiento Invalido")
		} 
		
	}
	
	//Metodo para volver a cero las variables del movimiento en cadena y limpia las fichas si acumuló y no comió
	method limpiarFichasAComer(){
				comidasSeguidasVertical=0
				comidasSeguidasHorizontal=0
				self.fichasAComer().clear()				
	}
	
	method superaLoslimtes(posicion){
		return posicion.x()>11 or posicion.x()<4 or posicion.y()>7 or posicion.y()<0
	}
	
	//Metodo para verificar si puede comer a la derecha
	method esPosibleComerDerecha(posicion){
	 
	  		return(
	 			turnero.contrincante().misFichas().any{ficha=>ficha.position()==game.at(posicion.x()+1,posicion.y()+self.haciaDonde())}
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
	 			turnero.contrincante().misFichas().any{ficha=>ficha.position()==game.at(posicion.x()-1,posicion.y()+self.haciaDonde())}
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
	
	//FICHA LE INDICA A SELECTOR QUE LA SUELTE Y JUGADOR DICE QUE YA MOVIÓ
	method terminarMovimiento(){
		marcoSelector.soltaFicha()
		self.pertenezcoA().yaMovi()
	}
	
	method transformarAReina(){
		//CAMBIAR SU IMAGEN
		tipo = damaReina
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
		ficha.terminarMovimiento()
	}
			
}

object damaReina{
	
	method puedoComer(posicion, ficha){
	}
	
	method puedoMoverme(destino, ficha){
		//1) ESTA VACÍO LA POSICION DESTINO
		//2) LAS CELDAS DE LA DIAGONAL ESTÁN TODAS VACIAS
		//self.recorrerDiagonal(destino, ficha)
	}
	
	method movete(destino, ficha){
		ficha.position(destino)
		ficha.vaciarListasDeCoordenadas() //LAS COORDENADAS ANTERIORES
		tablero.asignarCoordenadas()//USO LAS COORDENADAS DE LA FICHA COMO REFERENCIA
		tablero.invocador(0)		//LE ASIGNA LAS COORDENADAS A LAS LISTAS
		ficha.terminarMovimiento()
	}
	
	//RETORNA LOS ELEMENTOS DE LA DIAGONAL ENTRE LA FICHA Y EL DESTINO
	method recorrerDiagonal(destino, ficha){
		
		if(marcoSelector.masDerechaQueFichaSeleccionada()){
			//A LA DERECHA
			if(marcoSelector.masArribaQueFichaSeleccionada()){
				//ARRIBA
				return ficha.diagArribaDerecha().filter{c=>c.y()<destino.y()}.map{c=>game.getObjectsIn(c)}
			}else{
				//ABAJO
				return ficha.diagArribaDerecha().filter{c=>c.y()<destino.y()}.map{c=>game.getObjectsIn(c)}	
			}
		}else{
			//A LA IZQUIERDA
			if(marcoSelector.masArribaQueFichaSeleccionada()){
				//ARRIBA
				return ficha.diagArribaDerecha().filter{c=>c.y()<destino.y()}.map{c=>game.getObjectsIn(c)}	
								 
			}else{
				//ABAJO
				return ficha.diagArribaDerecha().filter{c=>c.y()<destino.y()}.map{c=>game.getObjectsIn(c)}	
				 
			}
		}
	}
	
	
}