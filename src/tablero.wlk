import wollok.game.*

object marcoSelector {
	var property position=game.at(0,0)
	var property fichaSeleccionada
	
	method asignarFicha(posicion){
		game.colliders(self).forEach{ficha=>if(ficha!=self){self.fichaSeleccionada(ficha)}}
	}
	
	method colocarFicha(posicion){
		self.fichaSeleccionada().move(posicion)
	}
	
	method move(nuevaPosicion) {
		self.position(nuevaPosicion)
		if(self.position().x()>7){
			self.position(game.at(7,self.position().y()))
		}
		if(self.position().x()<0){
			self.position(game.at(0,self.position().y()))
		}
				if(self.position().y()>7){
			self.position(game.at(self.position().x(),7))
		}
				if(self.position().y()<0){
			self.position(game.at(self.position().x(),0))
		}
	} 
	
	method image(){return "marco.png"}	

}
