class Trabajo{
	var faseParaTrabajar
	var base
	var bono
	
	
	
	method extra(fase)
	method esPresencial()

	method salario(){
		return base + self.extra(pandemia.fase())
	}

}



class Persona{
	const edad
	const enfermedadesPreexistentes 
	const trabajos = []
	const salidas = []
	
	
	method salir(salida){
		if(salida.puedeSalir(self)){
			salidas.add(salida)
		}
	}
	
	method agregarTrabajo(trabajo){
		trabajos.add(trabajo)
	}
	
	method sueldo(){
		return trabajos.sum({trabajo => trabajo.salario()})
	}
	
	method deRiesgo(){
		return edad >= 65 or enfermedadesPreexistentes
	}
	
	method trabajoPrincipal(){
		return trabajos.max({trabajo => trabajo.salario()})
	}
	
	method TrabajosSonPresenciales(){
		return trabajos.all({trabajo => trabajo.esPresencial()})
	}
	
	method puedeSalir(salida){
		return salida.puedeSalir(self)
	}
	
}

class Familia{
	var miembros = []
	var property trabajosPrincipales = []
	var property trabajadoresInactivos = []
	

	method salidaFamiliar(salida){
		const puedenSalir = miembros.filter({miembro => salida.puedeSalir(miembro)})
		if(puedenSalir.isEmpty()){
			self.error("na")
		}
		puedenSalir.forEach({miembro => miembro.salir(salida)})
	}	
	method agregar(unaPersona){
		miembros.add(unaPersona)
	}	
	
	method sueldoFamiliar(){
		return miembros.sum({miembro => miembro.sueldo()})
	}
	
	method estaAislada(){
		return miembros.all({miembro => miembro.deRiesgo()})
	}
	method TrabajosPrincipales(){
		const trabajos = miembros.map({miembro => miembro.trabajoPrincipal()})
		trabajosPrincipales.addAll(trabajos)
	}
	
	method cargarTrabajadoresInactivos(){
		const inactivos = miembros.filter({miembro => !miembro.TrabajosSonPresenciales()})
		trabajadoresInactivos.addAll(inactivos)
	}
	
}

class Salida{
	method puedeSalir(unaPersona)
}
class Trabajar inherits Salida{
	
	override method puedeSalir(unaPersona){
		return unaPersona.TrabajosSonPresenciales() and not unaPersona.deRiesgo()
	}
}


class Compra inherits Salida{
	override method puedeSalir(unaPersona){
		return not unaPersona.deRiesgo()
	}
}
class Ejercicio inherits Salida{
	override method puedeSalir(unaPersona){
		return not unaPersona.deRiesgo() and pandemia.fase() > 3
	}	
}
class Caminar inherits Ejercicio{
	
	override method puedeSalir(unaPersona){
		if(pandemia.fase() == 5){
			return true
		}else{
			return super(unaPersona)
		}
	}
	
		
}
class NoEscencial inherits Trabajo{
	
	override method extra(fase){
		if(self.esPresencial()){
			return bono
		}else{
			return 0
		}
	}
	
	override method esPresencial(){
		return faseParaTrabajar <= pandemia.fase()
	}
	
}

class Escencial inherits Trabajo{
	
	override method extra(fase){
		return bono *( (5- pandemia.fase() )/ 4)
	}
	
	override method esPresencial(){
		return true
	}
}

class Sanitario inherits Escencial{
	
	override method extra(fase){
		return 5000 + super(fase)
	}
	
}




object pandemia{
	var fase 
	method fase(numero){
		fase = numero
	}
	method fase() = fase
}
