import wollok.game.*
import tablero.*
import fichas.*
import jugadores.*

object juego {

	var property estadoActual
	var property ganador
	
	method comenzarPartida() {
		game.allVisuals().forEach{ visuales => game.removeVisual(visuales)}
		self.estadoActual(jugando)
		jugando.activarse()
	}

	method pausar() {
		self.estadoActual(enPausa)
		game.addVisual(enPausa)
		/*Si bien aquí ejecuta el metodo para finalizar los contadores, las variables de tiempo no se reinician con lo cual al volver de 
		la pausa se iniciaran en el tiempo que qudaron*/ 
		contador.terminaConteoDe("descontarUnSegundo")
		contador.terminaConteoDe("controlarTurno")
	}

	method reanudarJuego() {
		game.removeVisual(enPausa)
		self.estadoActual(jugando)
		//Vuelve a iniciar los contadores
		contador.iniciar()
		contador.iniciarConteoTurno(turnero.turnoDe())
	}

	method volverMenu() {
		//Se reinician todos los valores de tiempo, fichas y posiciones
		jugador1.misFichas().forEach{ ficha => jugador1.quitarFicha(ficha) }
		jugador2.misFichas().forEach{ ficha => jugador2.quitarFicha(ficha) }
		turnero.jugadorEnTurno(jugador1)
		jugador1.estado(enRojo)
		jugador2.estado(enBlanco)
		contador.tiempo(600)
		marcoSelector.position(game.at(4,2))
		contador.tiempoDeTurno(15)
		//Se activa el menu
		self.estadoActual(menuPrincipal)
		game.allVisuals().forEach{ visuales => game.removeVisual(visuales)}
		game.addVisual(menuPrincipal.opcionActual())
	}
	
	method finalizar(){
		contador.terminaConteoDe("descontarUnSegundo")
		game.allVisuals().forEach{ visuales => game.removeVisual(visuales)}
		game.addVisual(finalizado)
		self.estadoActual(finalizado)
		self.estadoActual().activarse()
	}

	method verTableros() {
		game.removeVisual(opcionTableros)
		game.addVisual(menuTableros.opcionActual())
		self.estadoActual(menuTableros)
	}

	method verReglas() {
		game.removeVisual(opcionReglas)
		game.addVisual(reglasPrimerPagina)
		self.estadoActual(reglasPrimerPagina)
	}

}

class EstadoDelJuego {
	
	var property image
	var property position
	
	//Acciones al presionar teclas 
	method accionS() {}
	method accionM() {}
	method accionP() {}
	method accionT() {}
	method accionIzq() {}
	method accionDer() {}
	method accionUp() {}
	method accionDown() {}
	method accionEnter() {}
	method accionBackspace() {}
	//Accion al activar el modo
	method activarse() {}
}

// Objetos relacionados con los distintos estados del juego

object jugando inherits EstadoDelJuego {

	override method image() = "fondoMadera.jpg"
	override method position() = game.at(0, 0)
	
	override method accionS() { marcoSelector.tomaFicha(marcoSelector.position()) }
	override method accionM() { marcoSelector.moveFicha(marcoSelector.position()) }
	//Antes de permitir terminar el turno se verifica que se haya movido o comido antes
	override method accionT() { if(marcoSelector.fichaSeleccionada().comerEnCadena()){marcoSelector.fichaSeleccionada().terminarMovimiento()}else{
		self.error("Debes mover o comer antes de terminar el turno")}}	
	override method accionP() { juego.pausar() }
	override method accionIzq() { marcoSelector.movete(marcoSelector.position().left(1)) }
	override method accionDer() { marcoSelector.movete(marcoSelector.position().right(1)) }
	override method accionUp() { marcoSelector.movete(marcoSelector.position().up(1)) }
	override method accionDown(){ marcoSelector.movete(marcoSelector.position().down(1)) }

	override method activarse() {
		
		// EMPIEZA EL JUEGO
		game.addVisual(self)
		game.addVisual(tablero)
		var clara1 = new FichaClara(position = game.at(4, 0))
		var clara2 = new FichaClara(position = game.at(6, 0))
		var clara3 = new FichaClara(position = game.at(8, 0))
		var clara4 = new FichaClara(position = game.at(10, 0))
		var clara5 = new FichaClara(position = game.at(5, 1))
		var clara6 = new FichaClara(position = game.at(7, 1))
		var clara7 = new FichaClara(position = game.at(9, 1))
		var clara8 = new FichaClara(position = game.at(11, 1))
		var clara9 = new FichaClara(position = game.at(4, 2))
		var clara10 = new FichaClara(position = game.at(6, 2))
		var clara11 = new FichaClara(position = game.at(8, 2))
		var clara12 = new FichaClara(position = game.at(10, 2))
		jugador1.agregarFichas([ clara1, clara2, clara3, clara4, clara5, clara6, clara7, clara8, clara9, clara10, clara11, clara12 ])
		var oscura1 = new FichaOscura(position = game.at(5, 7))
		var oscura2 = new FichaOscura(position = game.at(7, 7))
		var oscura3 = new FichaOscura(position = game.at(9, 7))
		var oscura4 = new FichaOscura(position = game.at(11, 7))
		var oscura5 = new FichaOscura(position = game.at(4, 6))
		var oscura6 = new FichaOscura(position = game.at(6, 6))
		var oscura7 = new FichaOscura(position = game.at(8, 6))
		var oscura8 = new FichaOscura(position = game.at(10, 6))
		var oscura9 = new FichaOscura(position = game.at(5, 5))
		var oscura10 = new FichaOscura(position = game.at(7, 5))
		var oscura11 = new FichaOscura(position = game.at(9, 5))
		var oscura12 = new FichaOscura(position = game.at(11, 5))
		jugador2.agregarFichas([ oscura1, oscura2, oscura3, oscura4, oscura5, oscura6, oscura7, oscura8, oscura9, oscura10, oscura11, oscura12 ])
		
		//Se visualizan las fichas de cada jugador
		jugador1.misFichas().forEach{ficha=>game.addVisual(ficha)}
		jugador2.misFichas().forEach{ficha=>game.addVisual(ficha)}
		
		//Se instancian y visualizan los marcadores de cada jugador
		var claraDec = new Marcador(numero = 1)
		var claraUni = new Marcador(numero = 2)
		var oscuraDec = new Marcador(numero = 1)
		var oscuraUni = new Marcador(numero = 2)
		jugador1.decenas(claraDec)
		jugador1.unidades(claraUni)
		jugador2.decenas(oscuraDec)
		jugador2.unidades(oscuraUni)
		game.addVisual(marcoSelector)
		game.addVisual(jugador1)
		game.addVisual(jugador2)
		game.addVisualIn(claraDec, game.at(1, 6))
		game.addVisualIn(claraUni, game.at(2, 6))
		game.addVisualIn(oscuraDec, game.at(1, 3))
		game.addVisualIn(oscuraUni, game.at(2, 3))
		
		// Instancia y visualiza todo lo referido al contador
		game.addVisual(contador)
		var minDec = new Marcador(numero = 1)
		var minUni = new Marcador(numero = 0)
		var segDec = new Marcador(numero = 0)
		var segUni = new Marcador(numero = 0)
		contador.mDecenas(minDec)
		contador.mUnidades(minUni)
		contador.sDecenas(segDec)
		contador.sUnidades(segUni)
		game.addVisualIn(minDec, game.at(0, 0))
		game.addVisualIn(minUni, game.at(1, 0))
		game.addVisualIn(segDec, game.at(2, 0))
		game.addVisualIn(segUni, game.at(3, 0))
		
		// inicia el conteo general y el primer conteo de turno
		contador.iniciar()
		contador.iniciarConteoTurno(jugador1)
	}

}

object menuPrincipal inherits EstadoDelJuego {

	var property opcionAnterior = null
	var property opcionActual = opcionJugar
	
	override method accionUp() {
		game.sound("menuSonido.ogg")
		opcionAnterior = opcionActual
		opcionActual = opcionActual.opcionDeArriba()
		game.addVisual(opcionActual)
		if (opcionActual != null) game.removeVisual(opcionAnterior)
	}

	override method accionDown() {
		game.sound("menuSonido.ogg")
		opcionAnterior = opcionActual
		opcionActual = opcionActual.opcionDeAbajo()
		game.addVisual(opcionActual)
		if (opcionActual != null) game.removeVisual(opcionAnterior)
	}

	override method accionEnter() {
		if (not opcionActual.equals(opcionSalir)) {
			game.sound("entrarOpcion.ogg")
		}
		opcionActual.accion()
	}
	
}

object enPausa inherits EstadoDelJuego {

	override method image() = "juegoPausa.png"
	override method position() = game.at(0, 0)
	override method accionEnter() { juego.reanudarJuego() }
	override method accionBackspace() { juego.volverMenu() }

}

object finalizado inherits EstadoDelJuego {

	override method image() = return juego.ganador().imagenGanadora()

	override method position() = game.at(0, 0)
	
	override method accionBackspace() { game.stop() }
	override method accionEnter() { juego.volverMenu() }
}



object reglasPrimerPagina inherits EstadoDelJuego {

	override method image() = "Reglas.jpg"
	override method position() = game.at(0, 0)
	
	override method accionDer() {
		game.sound("menuSonido.ogg")
		game.removeVisual(self)
		game.addVisual(reglasSegundaPagina)
		juego.estadoActual(reglasSegundaPagina)
	}

	override method accionBackspace() {
		game.sound("entrarOpcion.ogg")
		menuPrincipal.opcionAnterior(opcionJugar)
		menuPrincipal.opcionActual(opcionReglas)
		game.allVisuals().forEach({ visual => game.removeVisual(visual)})
		game.addVisual(menuPrincipal.opcionActual())
		juego.estadoActual(menuPrincipal)
	}

}

object reglasSegundaPagina inherits EstadoDelJuego {
	
	override method image() = "comoJugar.jpg"
	override method position() = game.at(0, 0)
	
	override method accionIzq() {
		game.sound("menuSonido.ogg")
		game.removeVisual(self)
		game.addVisual(reglasPrimerPagina)
		juego.estadoActual(reglasPrimerPagina)
	}

}

object menuTableros inherits EstadoDelJuego { 
	
	var opcionAnterior = null
	var property ultimaOpcion
	var property opcionActual = ultimaOpcion
	var property seleccionado
	
	override method accionUp() {
		game.sound("menuSonido.ogg")
		opcionAnterior = opcionActual
		opcionActual = opcionActual.opcionDeArriba()
		game.addVisual(opcionActual)
		if (opcionActual != null) game.removeVisual(opcionAnterior)
	}

	override method accionDown() {
		game.sound("menuSonido.ogg")
		opcionAnterior = opcionActual
		opcionActual = opcionActual.opcionDeAbajo()
		game.addVisual(opcionActual)
		if (opcionActual != null) game.removeVisual(opcionAnterior)
	}

	override method accionEnter() {
		game.sound("entrarOpcion.ogg")
		opcionActual.accion()
	}

	override method accionBackspace() {
		game.sound("entrarOpcion.ogg")
		menuPrincipal.opcionAnterior(opcionReglas)
		menuPrincipal.opcionActual(opcionTableros)
		game.allVisuals().forEach({ visual => game.removeVisual(visual)})
		game.addVisual(menuPrincipal.opcionActual())
		juego.estadoActual(menuPrincipal)
	}
	
}

// Objetos relacionados con las opciones del menu principal y el menu de tableros

object opcionJugar {

	var property opcionDeArriba = opcionSalir
	var property opcionDeAbajo = opcionReglas

	method image() = "menuPrincipalJugar.jpg"

	method position() = game.at(0, 0)

	method accion() { juego.comenzarPartida() }

}

object opcionReglas {

	var property opcionDeArriba = opcionJugar
	var property opcionDeAbajo = opcionTableros

	method image() = "menuPrincipalReglas.jpg"

	method position() = game.at(0, 0)

	method accion() { juego.verReglas() }
		
}


object opcionTableros {

	var property opcionDeArriba = opcionReglas
	var property opcionDeAbajo = opcionSalir

	method image() = "menuPrincipalTableros.jpg"

	method position() = game.at(0, 0)

	method accion() {
		juego.verTableros()
	}

}

object opcionSalir {

	var property opcionDeArriba = opcionTableros
	var property opcionDeAbajo = opcionJugar

	method image() = "menuPrincipalSalir.jpg"

	method position() = game.at(0, 0)

	method accion() {
		game.stop()
	}

}


object opcionTableroClasico {

	var property opcionDeArriba = opcionTableroWollok
	var property opcionDeAbajo = opcionTableroArgento

	method image() = "opcionTableroClasico.jpg"

	method position() = game.at(0, 0)
	
	method accion(){
		tablero.posicionLista(0)
		menuTableros.ultimaOpcion(self)
		menuTableros.accionBackspace()
	}

}



object opcionTableroArgento {

	var property opcionDeArriba = opcionTableroClasico
	var property opcionDeAbajo = opcionTableroMadera

	method image() = "opcionTableroArgento.jpg"

	method position() = game.at(0, 0)
	
	method accion(){
		tablero.posicionLista(1)
		menuTableros.ultimaOpcion(self)
		menuTableros.accionBackspace()
	}

}


object opcionTableroWollok {

	var property opcionDeArriba = opcionTableroMadera
	var property opcionDeAbajo = opcionTableroClasico

	method image() = "opcionTableroWollok.jpg"

	method position() = game.at(0, 0)
	
	method accion(){
		tablero.posicionLista(2)
		menuTableros.ultimaOpcion(self)
		menuTableros.accionBackspace()
	}

}

object opcionTableroMadera {

	var property opcionDeArriba = opcionTableroArgento
	var property opcionDeAbajo = opcionTableroWollok

	method image() = "opcionTableroMadera.jpg"

	method position() = game.at(0, 0)
	
	method accion(){
		tablero.posicionLista(3)
		menuTableros.ultimaOpcion(self)
		menuTableros.accionBackspace()
	}

}

