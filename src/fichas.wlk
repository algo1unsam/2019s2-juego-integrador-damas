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
	
	//var _esReina = false

		 	
	method validar(nuevaPosicion) {
		if(self.puedoMoverme(nuevaPosicion)) {
			self.movete(nuevaPosicion)			
		}else if(self.puedoComer(position)){
			self.comerEncadenado()
		}else{
			marcoSelector.error("Ese movimiento no es válido")
		}
	}

	//SE VALIDA MOVIMIENTO EN DIAGONAL SIMPLE
	method puedoMoverme(posicion){
		return (posicion.equals(self.diagonalDerecha()) or posicion.equals(self.diagonalIzquierda())) and marcoSelector.estaVacio()
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
		return	self.esPosibleComerDerecha(posicion) or self.esPosibleComerIzquierda(posicion)				
	}
	
	method laPosicion(){
		return game.at(position.x()+comidasSeguidasHorizontal,position.y()+comidasSeguidasVertical*self.haciaDonde())
	}

	method comerEncadenado(){
		var fichas=[]
		
		//Verifica si puede comer
		if(self.puedoComer(self.laPosicion())){
			//Verifica si puede comer a la izquierda o a la derecha
			if(self.esPosibleComerDerecha(self.laPosicion())){
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
	
	//Metodo para verificar si puede comer a la derecha
	method esPosibleComerDerecha(posicion){
	 
	  		return(
	 			turnero.contrincante().misFichas().any{ficha=>ficha.position()==game.at(posicion.x()+1,posicion.y()+self.haciaDonde())}
	 			and
	  			turnero.contrincante().misFichas().all{ficha=>ficha.position()!=game.at(posicion.x()+2,posicion.y()+self.haciaDonde()*2)}
	  			and
	 			self.pertenezcoA().misFichas().all{ficha=>ficha.position()!=game.at(posicion.x()+2,posicion.y()+self.haciaDonde()*2)}
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
	 		)
	 }
	  
	//SE MUEVE UNA POSICIÓN QUE LE LLEGA DEL MARCO SELECTOR
	method movete(nuevaPosicion){
		position = nuevaPosicion
		self.terminarMovimiento()
	}

	
	//FICHA LE INDICA A SELECTOR QUE LA SUELTE Y JUGADOR DICE QUE YA MOVIÓ
	method terminarMovimiento(){
		marcoSelector.soltaFicha()
		self.pertenezcoA().yaMovi()
	}
	
			
	//METODOS SOBREESCRITOS EN CLASES HIJAS
	method haciaDonde()
	method image()
	method pertenezcoA()

}

class FichaClara inherits Ficha {
	var imagenes = [ "fichaClara.png", "fichaSeleccionada.png"]
	
	override method haciaDonde(){
		return 1
	} 

	override method image() {
		return imagenes.get(estado.devolvePosicion())
	}
	
	override method pertenezcoA(){
		return jugador1
	}
	
}

class FichaOscura inherits Ficha {
	var imagenes = [ "fichaOscura.png", "fichaSeleccionada.png"]
		
	override method haciaDonde(){
		return -1
	}
	
	override method image() {
		return imagenes.get(estado.devolvePosicion())
	}
	
	override method pertenezcoA(){
		return jugador2
	}
		
}

