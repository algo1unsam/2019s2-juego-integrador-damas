import wollok.game.*
import fichas.*
import jugadores.*
import menuPrincipal.*

object tablero {

	var property position = game.at(4, 0)
	var imagenes=["tableroClasico.jpg","tableroArgento.jpeg","tableroWollok.jpeg","tableroMadera.jpg"]
	
	//Variable para seleccionar que imagen de tablero va (se cambia en el menu principal) 
	var property posicionLista=0
		
	//limites del tablero
	const property topeIzq = 4
	const property topeDer = 11
	const property topeSup = 7
	const property topeInf = 0
	
	var x = 0
	var y = 0

	method image() {
		return imagenes.get(posicionLista)
	}
	
	method loQueHayEn(posicion){
		if(game.getObjectsIn(posicion)!=[])
			return game.getObjectsIn(posicion).uniqueElement()
		else
			return null			
	}
	
	method quitarFicha(ficha){
		game.removeVisual(ficha)
	}
	
	
	method derechaArriba(){
		if(x<topeDer and y<topeSup){
			x += 1
			y += 1
			marcoSelector.fichaSeleccionada().diagArribaDerecha().add(game.at(x,y))
			self.invocador(0)
		}else{
			self.asignarCoordenadas()
			self.invocador(1)
		}
	}
	
	method derechaAbajo(){
		if(x<topeDer and y>topeInf){
			x += 1
			y -= 1
			marcoSelector.fichaSeleccionada().diagAbajoDerecha().add(game.at(x,y))
			self.invocador(1)
		}else{
			self.asignarCoordenadas()
			self.invocador(2)
		}
	}
	
	method izquierdaArriba(){
		if(x>topeIzq and y<topeSup){
			x -= 1
			y += 1
			marcoSelector.fichaSeleccionada().diagArribaIzquierda().add(game.at(x,y))
			self.invocador(2)
		}else{
			self.asignarCoordenadas()
			self.invocador(3)
		}
	}
	
	method izquierdaAbajo(){
		
		if(x>topeIzq and y>topeInf){
			x -= 1
			y -= 1
			marcoSelector.fichaSeleccionada().diagAbajoIzquierda().add(game.at(x,y))
			self.invocador(3)
		}else{
			self.asignarCoordenadas()
		}
	
	}
	
	method asignarCoordenadas(){
		x = marcoSelector.fichaSeleccionada().position().x()
		y = marcoSelector.fichaSeleccionada().position().y()
	}
	
	//SE INVOCA DE FORMA RECURSIVA CON LOS METODOS:
	//derechaArriba(), derechaAbajo(), izquierdaArriba(), izquierdaAbajo()
	//HASTA QUE SE LLEGAN A LOS LÍMITES DEL TABLERO	
	method invocador(indice){
		if(indice == 0)
			self.derechaArriba()
		if(indice == 1)
			self.derechaAbajo()
		if(indice == 2)
			self.izquierdaArriba()
		if(indice == 3)
			self.izquierdaAbajo()
	}
	
}

object marcoSelector {

	var property position = game.at(4, 2)
	var property fichaSeleccionada=null
	
	//Metodo para verificar si ya tiene una fichaSeleccionada
	method tengoFicha(){
		return fichaSeleccionada!=null
	}
	
	method tomaFicha(posicion) {
		// Si tengo una fichaSeleccionada debo usar esa no la puedo soltar en este turno
		if (self.tengoFicha()) {
			game.say(self, "Ya escogiste una ficha para mover, no puedes cambiarla")
		} else {
			game.colliders(self).forEach{ ficha =>
				if (ficha != (self) and turnero.turnoDe().misFichas().contains(ficha)) {
					fichaSeleccionada = ficha
					fichaSeleccionada.estado(enRojo)
				}else { game.say(self, "No puedes seleccionar esta ficha") }
			}
				// Comprueba que la fichaSeleccionada pueda mover o comer, si no puede la suelta
			if (self.tengoFicha()) {
				if (game.getObjectsIn(fichaSeleccionada.diagonalDerecha()) != [] and game.getObjectsIn(fichaSeleccionada.diagonalIzquierda()) != [] and not fichaSeleccionada.puedoComer(fichaSeleccionada.position())) {
					self.soltaFicha()
				}
			}
		}
	}
	//EL SELECTOR PRUEBA MOVER FICHA y da error si no hay ficha seleccionada
	method moveFicha(posicion) {
		if (fichaSeleccionada != null){ 
			fichaSeleccionada.validar(posicion)
		}else{
			self.error("No seleccionó una ficha para mover")
		}
		
	}
	
	//EL SELECTOR SUELTA LA FICHA
	method soltaFicha(){
		//Esta condición se crea por si pasa el tiempo de turno y el jugador no seleccionó ficha, sino tiraría error 
		if(fichaSeleccionada!=null){
			fichaSeleccionada.estado(enBlanco)
			fichaSeleccionada = null
		}
	}
	
	//MUEVE EL MARCO SELECTOR
	method movete(nuevaPosicion) {
		position = nuevaPosicion
		if (position.x() > tablero.topeDer()) {
			position = game.at(tablero.topeDer(), position.y())
		}
		if (position.x() < tablero.topeIzq()) {
			position = game.at(tablero.topeIzq(), position.y())
		}
		if (position.y() > tablero.topeSup()) {
			position = game.at(position.x(), tablero.topeSup())
		}
		if (position.y() < tablero.topeInf()) {
			position = game.at(position.x(), tablero.topeInf())
		}
	}

	method image() {
		return "marco.png"
	}
	
	method estaVacio(){
		return game.colliders(self).all{elemento => elemento == self}
	}
	
	method masDerechaQueFichaSeleccionada(){
		return position.x() - fichaSeleccionada.position().x() > 0
	}
	
	
	method masArribaQueFichaSeleccionada(){
		return position.y() - fichaSeleccionada.position().y() > 0
	}
	
	
}

object turnero {

	var property jugadorEnTurno = jugador1
	const jugadores = [jugador1,jugador2]	
	
	method turnoDe() {
		return jugadorEnTurno
	}
	
	method cambiaTurno(jugador){
		jugadorEnTurno = jugadores.find({e=>e!=jugador})
		game.say(marcoSelector, "Turno de: " + jugadorEnTurno.nombre())
		
		//Indica al marcador del turno que empieza la cantidad de fichas que le queda a es jugador 
		var cuantasFichas = jugadorEnTurno.misFichas().size()
		if(cuantasFichas==0){
			juego.ganador(self.contrincante())
			juego.finalizar()
		}else{
			var decena = cuantasFichas / 10
			var unidad = cuantasFichas % (10)
			jugadorEnTurno.decenas().asignarNumero(decena.truncate(0))
			jugadorEnTurno.unidades().asignarNumero(unidad)
			
			//Cambia las imagenes del jugadorEnTurno y del contrincante
			jugadorEnTurno.estado(enRojo)
			jugadorEnTurno.image()
			self.contrincante().estado(enBlanco)
			self.contrincante().image()		
			
			//Inicia el contador de turno para el turno que empieza
			contador.iniciarConteoTurno(jugadorEnTurno)	
		}
	}
	//RETORNA AL JUGADOR QUE ESTÁ ESPERANDO EL MOVIMIENTO
	method contrincante(){
		return jugadores.find({jugador=>not jugador.equals(jugadorEnTurno)})
	}

}

class Marcador {
	var listaDeNumeros = [ "numCero.png", "numUno.png", "numDos.png", "numTres.png", "numCuatro.png", "numCinco.png", "numSeis.png", "numSiete.png", "numOcho.png", "numNueve.png" ]
	var numero

	method listaDeNumeros() {
		return listaDeNumeros
	}

	method asignarNumero(nuevoNumero) {
		numero = nuevoNumero
		self.image()
	}

	method image() {
		return self.listaDeNumeros().get(numero)
	}

}

object contador{
	var property position = game.at(0, 0)
	//Atributo de tiempo límite por juego
	var property tiempo=600
	//Atributos para cambiar el marcador
	var property mDecenas
	var property mUnidades
	var property sDecenas	
	var property sUnidades
	//Atributo para el color de las Imagenes
	var property estado=enBlanco
	var imagenes = [ "contador.png", "contadorAlerta.png"]
	//Atributo de tiempo límite por turno
	var property tiempoDeTurno=15
	
	method image() {
		return imagenes.get(estado.devolvePosicion())
	}
	
	//Contador general de juego
	method iniciar(){
		game.onTick(1000, "descontarUnSegundo", { 
			tiempo-=1
			var minDecena = tiempo / 600
			var minUnidad = tiempo / 60
			var segDecena = tiempo % (60) / 10
			var segUnidad = (segDecena - segDecena.truncate(0))*10
			self.mDecenas().asignarNumero(minDecena.truncate(0))
			self.mUnidades().asignarNumero(minUnidad.truncate(0))
			self.sDecenas().asignarNumero(segDecena.truncate(0))
			self.sUnidades().asignarNumero(segUnidad.truncate(0))
			
			//Cambia de color a falta de un minuto
			if (tiempo==60){
				self.estado(enRojo)
				self.image()
			}
			
			//Si el tiempo llega a cero termina el conteo y finaliza con la placa empate
			if (tiempo==0){
				self.terminaConteoDe("controlarTurno")
				juego.ganador(empate)
				juego.finalizar()
			}
		})
	}
	
	//Conteo para el turno del jugador (el tiempo lo determina el atributo tiempoturno)
	method iniciarConteoTurno(jugador){
		game.onTick(1000, "controlarTurno", { 
			tiempoDeTurno-=1
			if (tiempoDeTurno==0){
				self.terminaConteoDe("controlarTurno")
				
				if(marcoSelector.fichaSeleccionada()!=null){
					marcoSelector.fichaSeleccionada().comerEnCadena(false)
					marcoSelector.soltaFicha()
				}
				tiempoDeTurno=15	
				turnero.cambiaTurno(jugador)
			}
		})
	}
	
	//Termina cualquier evento que se le pase por parametro
	method terminaConteoDe(nombre){
		game.removeTickEvent(nombre)
	}
	
}

//OBJETOS PARA MANEJAR LA LISTA DE IMAGENES DE LOS OBJETOS QUE PUEDEN TENER IMAGEN EN BLANCO O EN COLOR
object enBlanco{
	method devolvePosicion(){
		return 0
	} 
}

object enRojo{
	method devolvePosicion(){
		return 1
	} 
}
