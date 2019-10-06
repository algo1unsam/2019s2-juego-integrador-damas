import wollok.game.*

class FichaClara {
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
	
	method image(){return "fichaClara.png"}

}

class FichaOscura {
	var property position 
	
	method image(){return "fichaOscura.png"}

}