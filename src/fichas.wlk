import wollok.game.*

class FichaRoja {
	var property position 
	var direccionMovimiento=1
	
	method move(nuevaPosicion) {
		if(self.puedoMoverme(nuevaPosicion)){
			self.position(nuevaPosicion)
		}
	}
	
	method puedoMoverme(posicion){
		return (posicion.x()==self.position().x()+1 or posicion.x()==self.position().x()-1) and posicion.y()==self.position().y()+direccionMovimiento
	} 
	
	method estaVacio(posicion){
		
	}
	
	method image(){return "fichaRoja.png"}

}

class FichaNegra {
	var property position 
	
	method image(){return "fichaNegra.png"}

}