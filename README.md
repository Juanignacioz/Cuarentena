# Cuarentena


## Aclaraciones sobre el parcial
- El parcial es **individual** y se entrega **pusheando a este repositorio** como en las entregas anteriores. Recomendamos _ir pusheando cada cierto tiempo_ para evitar inconvenientes, lo ideal es después de cada punto resuelto.
- No se tendrán en cuenta los commits realizados después de la hora de finalización del examen.
- Una vez hecho el _push_ final, **verifiquen en github.com** que haya quedado la versión final. Nosotros corregiremos lo que está en github, si ustedes lo pueden ver ahí entonces nosotros también.
- No olvidarse de **los conceptos aprendidos**: polimorfismo, delegación, buenas abstracciones, no repetir lógica, guardar vs calcular, lanzar excepción cuando un método no puede cumplir con su responsabilidad, etc. Eso es lo que se está evaluando.
- La solución del examen consiste en la **implementación de un programa** que resuelva los requerimientos pedidos y sus **tests automatizados**.
- Este enunciado es acompañado con un archivo `.wtest` que tiene diseñado los test a realizar. Es importante aclarar que:
  - Estos tests se proponen para facilitar el desarrollo. Se puede diseñar otros si así se considera necesario.
  - El conjunto de tests propuesto es suficiente para este ejercicio. No hace falta agregar nuevos, pero tampoco se prohibe hacerlo.
  - Todos los objetos allí usados se asumen como instancias de una clase. Si el diseño de la solución utiliza objetos bien conocidos en algunos casos entonces se debe remover la declaración de la variable y la línea en que se sugiere la instanciación
  - Según el diseño de la solución, es probable que se requiera agregar más objetos a los sugeridos en los tests
  - Los tests están comentados de manera de poder _ir incorporándolos a medida que se avanza_ con la solución del ejercicio

## Contexto 

Dada la problématica de la Pandemia Covid-19 se necesita un sistema que
permita modelar las distintas actividades que puedan realizar las personas
que se encuentran en aislamiento obligatorio.

> Este es un sistema acotado por fines pedagógicos y no representa
la totalidad de los casos ni la complejidad que tendría un sistema real.

## Modelo inicial

De la **pandemia** se conoce en que **fase** está, que es un número entre 1 y 5 
que puede ser modificado por el usuario del sistema. 
Este valor es consultado por distintos objetos del sistema para tomar decisiones.

De una **persona** se conoce su **edad**, si posee **enfermedades preexistentes** y todos sus **trabajos**.

De los **trabajos** interesa saber:
- Si se **pueden realizar presencialmente** o no (eso depende del tipo de trabajo) 
- El **salario** se calcula como la suma de un número **base** más un **extra**. 
El **extra** es un cálculo que se realiza a partir un número **bono**. 
Tanto la **base** como el **bono** son números que se determinan para cada trabajo, 
mientras que la manera en que se usa el bono para calcular el extra depende del tipo de trabajo.


Existen los siguientes trabajos: 
- Los **trabajos no esenciales** se pueden realizar a partir de una fase de la pandemia 
que se indica para cada trabajo.
El extra es el bono en el caso que el trabajo se pueda realizar presencialmente. En otro caso
es 0.

- Los **trabajos esenciales** son aquellos que se pueden desarrollar presencialmente 
en cualquier fase de la pandemia. 
El extra se calcula como ` bono * ((5 - __fase actual de la pandemia__) / 4 )` 

- Los **trabajos sanitarios** son trabajos esenciales que reciben $5000 más de extra 
  que un trabajo esencial normal.

Una **familia** está compuesta por varias **personas**. 

### Estos son casos de ejemplos que pueden ser utilizados en los tests:

- Trabajos No esenciales:
    - Programador/a : Se puede realizar a partir de la fase 3, paga 80000 de base y 20000 de bono   
    - Docente : Se puede realizar a partir de la fase 5, paga 15000 de base y 5000 de bono
- Trabajos Esenciales
    - Panadero/a : Paga 30000 de base y 20000 de bono
- Trabajos Sanitarios
    - Médico/a : Paga 60000 de base y  40000 de bono

- Personas:
    - Milena es programadora y docente, tiene 25 años y tiene enfermedades prexistentes
    - Nicolás es panadero, tiene 19 años y no tiene enfermedades preexistenes
    - Mirta es Médica, tiene 67 años y no tiene enfermedades preexistentes   

- Familia:
    - La familia Perez-García está compuesta por Milena, Mirta y Nicolás.
 
## 1. Consultas sobre el modelo
Nos interesa saber:

1. **Cuanto gana una persona**: Es la suma de los sueldos de sus trabajos
2. **Cuanto gana una familia**: Es la suma de los ingresos de sus integrantes
3. **Si una familia está aislada**: Sucede cuando todos sus miembros están en riesgo. 
Un miembro está en riesgo si tiene 65 o más años o si posee una enfermedad preexistente.
4. **Los trabajos principales de una familia**: Es la colección formada por el trabajo principal 
de cada integrante de la familia. El trabajo principal de una persona es aquel que le aporta 
mayores ingresos. Se puede asumir que no hay integrantes sin trabajos. 
5. **Los trabajadores inactivos de una familia** que son aquellos que no puedan realizar ninguno 
de sus trabajos de manera presencial.

_Atención! Prestar atención a la división de responsabilidades._  

# 2. Salidas

Las salidas son actividades que las personas pueden hacer o no dependiendo de varios factores específicos.
En este sistema vamos a modelar solamente 4 actividades: __salir a comprar, trabajar, pasear o ejercitarse__.

- **salir a trabajar**: La persona no debe estar en riesgo y debe poder trabajar presencialmente (resuelto en el punto anterior).
- **salir a comprar**: La persona no debe estar en riesgo.
- **salir a realizar ejericicio**: La persona no debe estar en riesgo y la fase de la pandemia debe ser mayor a 3.
- **salir a caminar**: Al igual que para realizar ejercicio, la persona no debe estar en riesgo y la fase de la pandemia debe ser mayor a 3. 
Aunque si la pandemia está en fase 5 cualquier persona puede salir a caminar (esté en riesgo o no). 

_Atención! No duplicar código! Prestar atención a las ideas repetidas._

Se pide:

1. Saber si una persona puede realizar una salida
2. Indicar que una persona realiza una salida: Validar que la misma se pueda realizar
y registrar que se realizó en el caso satisfactorio.
3. Saber el historial de salidas de una persona, manteniendo el orden y repeticiones que hagan falta.
4. Asumiendo el escenario de ejemplo planteado al prinicipio del enunciado y  
que la pandemia está en fase 4, escribir los siguientes tests que cubren los dos puntos anteriores.

- Se le pide a Nicolás que salga a comprar, luego a trabajar y luego a comprar nuevamente. 
Asegurarse que el historial de salidas sea una colección de tamaño 3, 
cuyo primer elemento modele la salida a comprar, el segundo la salida a trabajar 
y el tercero la salida a comprar     

- Se le pide a Milena que salga a comprar, esta es una acción que no se 
debería poder hacer porque ella es una persona en riesgo.  


# 3. Salida Familiar

A una **familia** se le puede solicitar que realice una **salida**. Las salidas son las mismas 
resueltas en el punto anterior.

**Todos los miembros que son capaces de realizar la salida la realizan.** Los miembros que no
la pueden realizar simplemente no lo hacen. Sin embargo es necesario para cumplir 
el requerimiento que **al menos uno de los integrantes** de la familia puedan llevar 
adelante la salida. 

Escribir un test en el cual se le solicita a la familia perez garcía que salga a comprar.
En ese caso solo nicolás realiza la acción.  




