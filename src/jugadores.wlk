import wollok.game.*
import tablero.*
import fichas.*

object jugador1 {
	const fichas = []
	const fichasRestantes = []
	
	method misFichas(){
		return fichasRestantes
	}
	
	method agregarFichas(ficha){
		fichas.add(ficha)
		fichasRestantes.add(ficha)
	}
}

object jugador2 {
	const fichas = []
	const fichasRestantes = []

	method misFichas(){
		return fichasRestantes
	}
	
	method agregarFichas(ficha){
		fichas.add(ficha)
		fichasRestantes.add(ficha)
	}

}