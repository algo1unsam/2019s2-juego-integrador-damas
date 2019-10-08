import wollok.game.*

class Ficha {
	var property position
	 	
	method move(nuevaPosicion) {
		if(self.puedoMoverme(nuevaPosicion)){
			self.position(nuevaPosicion)
		}
	}
	
	method puedoMoverme(posicion){
		return (posicion.x()==self.position().x()+1 or posicion.x()==self.position().x()-1) and posicion.y()==self.position().y()+1*self.haciaDonde()
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