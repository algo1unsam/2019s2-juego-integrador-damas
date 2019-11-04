import wollok.game.*
import tablero.*
import fichas.*
import jugadores.*

object juego {

	var property estadoActual

	method comenzar() {
		game.allVisuals().forEach{ visuales => game.removeVisual(visuales)}
		self.estadoActual(jugando)
		jugando.activarse()
	}

	method pausar() {
		self.estadoActual(pausado)
		pausado.activarse()
	}

	method reanudarJuego() {
		game.removeVisual(pausado)
		self.estadoActual(jugando)
		contador.iniciar()
	}

	method volverMenu() {
		self.estadoActual(menuPrincipal)
		game.allVisuals().forEach{ visuales => game.removeVisual(visuales)}
		menuPrincipal.navegar()
	}

	method opciones() {
	}

	method reglas() {
		game.removeVisual(opcionReglas)
		game.addVisual(reglas)
		self.estadoActual(reglas)
	}

}

object jugando {

	var property primeraVez

	method image() = "fondoMadera.jpg"

	method position() = game.at(0, 0)

	method activarse() {
		
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
		game.addVisual(clara1)
		game.addVisual(clara2)
		game.addVisual(clara3)
		game.addVisual(clara4)
		game.addVisual(clara5)
		game.addVisual(clara6)
		game.addVisual(clara7)
		game.addVisual(clara8)
		game.addVisual(clara9)
		game.addVisual(clara10)
		game.addVisual(clara11)
		game.addVisual(clara12)
		game.addVisual(oscura1)
		game.addVisual(oscura2)
		game.addVisual(oscura3)
		game.addVisual(oscura4)
		game.addVisual(oscura5)
		game.addVisual(oscura6)
		game.addVisual(oscura7)
		game.addVisual(oscura8)
		game.addVisual(oscura9)
		game.addVisual(oscura10)
		game.addVisual(oscura11)
		game.addVisual(oscura12)
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

object pausado {

	method image() = "juegoPausa.png"

	method position() = game.at(0, 0)

	method activarse() {
		game.addVisual(self)
	}

}

object menuPrincipal {

	var property opcionAnterior = null
	var property opcionActual = opcionJugar
	var property ultimaOpcion

	method navegar() {
		game.addVisual(opcionActual)
	}

}

object opcionJugar {

	var property opcionDeArriba = opcionSalir
	var property opcionDeAbajo = opcionReglas

	method image() = "menuPrincipalJugar.jpg"

	method position() = game.at(0, 0)

	method accion() {
		juego.comenzar()
	}

}

object opcionReglas {

	var property opcionDeArriba = opcionJugar
	var property opcionDeAbajo = opcionOpciones

	method image() = "menuPrincipalReglas.jpg"

	method position() = game.at(0, 0)

	method accion() {
		juego.reglas()
	}

}

object reglas {

	method image() = "Reglas.jpg"

	method position() = game.at(0, 0)

}

object opcionOpciones {

	var property opcionDeArriba = opcionReglas
	var property opcionDeAbajo = opcionSalir

	method image() = "menuPrincipalOpciones.jpg"

	method position() = game.at(0, 0)

	method accion() {
		juego.opciones()
	}

}

object opcionSalir {

	var property opcionDeArriba = opcionOpciones
	var property opcionDeAbajo = opcionJugar

	method image() = "menuPrincipalSalir.jpg"

	method position() = game.at(0, 0)

	method accion() {
		game.stop()
	}

}
