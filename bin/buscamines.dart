import 'dart:math';
import 'dart:io';



void main(List<String> arguments) {

  // Constantes del tablero
  const int filas = 6;
  const int columnas = 10;
  const int totalMinas = 8;
  


  // Generar el tablero
  // Generar la lista principal(Matriz) que sera el tablero
  // .   = Casilla sin descubrir
  // " " = Casilla descubierta sin minas alrededor
  // 1~8 = Numero de minas adyacentes
  // #   = bandera
  // *   = mina
  List<List<String>> tablero = List.generate(

    // Generar las listas que seran las filas dentro de la lista principal
    filas,
    (_) => List.generate(

      // Generar los strings que seran las columnas dentro de las filas
      columnas, 
      (_) => '·'
    ),
  ); 


  // Generar la lista principal(Matriz) de minas
  // true = Hay mina en esa posicion
  // false = No hay mina en esa posicion
  List<List<bool>> minas = List.generate(

    // Generar las listas que seran las filas dentro de la lista principal
    filas,
    (_) => List.generate(

      // Llenar la lista de flase, mas adelante se 
      // colocaran las minas al azar por cuadrantes
      columnas, (_) => false
      ),
  );

  // Colocar las minas por cuadrantes en la matriz
  // Superior
  // Izquierdo 
  colocarMinas(minas, 0, 3, 0, 5);
  // Derecho
  colocarMinas(minas, 0, 3, 5, 10);
  // Inferior
  // Izquierdo
  colocarMinas(minas, 3, 6, 0, 5);
  // Derecho
  colocarMinas(minas, 3, 6, 5, 10);


  mostrarTablero(tablero);
}



// Funcion para colocar las minas entre ciertas filas y columnas del tablero
void colocarMinas(
  List<List<bool>> minas,
  int filaInicio,
  int filaFin,
  int columnaInicio,
  int columnaFin,
) {

  // Crear el generador de numeros y el contador de minas
  Random generadorAzar = Random();
  int colocadas = 0;

  // Bucle para colocar solo 2 minas entre las filas y columnas
  while (colocadas < 2) {

    // Seleccionar la fila y la columna donde habra una mina
    int fila = filaInicio + generadorAzar.nextInt(filaFin - filaInicio);
    int columna = columnaInicio + generadorAzar.nextInt(columnaFin - columnaInicio);

    // Condicion para ver si en la posicion seleccionada al azar habia una mina
    if (!minas[fila][columna]) {

      // Si no hay ninguna mina, poner una mina alli 
      // y sumar la cantidad de minas en 1 al contador
      minas[fila][columna] = true;
      colocadas++;
    }
  }
}

// Funcion para contar las minas que hay alrededor de la casilla seleccionada
int contarMinasAdyacentes(
  List<List<bool>> minas,
  int fila,
  int columna,
) {

  // Crear el contador de minas
  int contador = 0;

  // Comprobar las casillas en un cuadrado 3x3
  // Bucle para revisar las filas
  for (
    int desplazamientoFila = -1; 
    desplazamientoFila <= 1; 
    desplazamientoFila++
  ) {

    // Bucle para revisar las columnas
    for (
      int desplazamientoColumna = -1; 
      desplazamientoColumna <= 1; 
      desplazamientoColumna++
    ) {

      // Condicion para no revisar la casilla central
      if (desplazamientoFila == 0 && desplazamientoColumna == 0) {
        continue;
      }

      // Calcular la posicion que queremos comprobar
      int nuevaFila = fila + desplazamientoFila;
      int nuevaColumna = columna + desplazamientoColumna;

      // Comprobar que la posicion este dentro del tablero
      if (
        nuevaFila >= 0 &&
        nuevaFila < minas.length &&
        nuevaColumna >= 0 &&
        nuevaColumna < minas[0].length
      ) {

        // Comprobamos si hay una mina
        if (minas[nuevaFila][nuevaColumna]) {
          contador++;
        }
      }
    }
  }

  // Devolver la cantidad de minas que hay alrededor de la casilla
  return contador;
}

// Funcion para mostrar el estado actual del tablero
void mostrarTablero(List<List<String>> tablero) {

  // Lista de letras que apareceran en el borde de las filas
  List<String> letras = ['A', 'B', 'C', 'D', 'E', 'F'];

  // Añadir la esquina superior izquierda para que los numeros
  // de las columnas se vean en la posicion adequada
  stdout.write(' ');

  // Mostrar números de las columnas
  for (int columna = 0; columna < tablero[0].length; columna++) {
    stdout.write(columna);
  }

  // Salto de linea para pasar a la siguiente fila
  print('');

  // Bucle para recorrer las filas
  for (int fila = 0; fila < tablero.length; fila++) {

    // Poner las letras de las filas al borde de cada fila
    stdout.write(letras[fila]);

    // Bucle para recorrer las columnas
    for (int columna = 0; columna < tablero[fila].length; columna++) {

      // Imprimir las casillas por pantalla
      stdout.write(tablero[fila][columna]);
    }

    // Salto de linea para pasar a la siguiente fila
    print('');
  }


}

// Funcion para destapar las casillas y comprobar si una mina explota
bool destaparCasilla(
  List<List<String>> tablero,
  List<List<bool>> minas,
  int fila,
  int columna,
  bool esPrimeraJugada,
  bool esJugadaUsuario,
) {

  // Comprobacion si la casilla es valida
  if (
    fila < 0 ||
    fila >= tablero.length ||
    columna < 0 ||
    columna >= tablero[0].length ||
    tablero[fila][columna] != '·'
  ) {
    return false;
  }

  // Comprobar si en la casilla seleccionada hay una mina
  if (minas[fila][columna]) {

    // Mover la mina a otra posición
    if (esPrimeraJugada) {
      moverMina(minas, fila, columna);
      
    // Si el jugador ha seleccionado la mina explota
    } else if (esJugadaUsuario) {
      return true;

    // La funcion esta descubriendo la casilla durante la recursividad,
    // a si que no hace nada
    } else {
      return false;
    }
  }

  // Contar las minas adyacentes
  int numeroMinas = contarMinasAdyacentes(minas, fila, columna);

  // Actualizar el tablero
  // Si no hay ninguna mina adyacente, vaciar la casilla
  if (numeroMinas == 0) {
    tablero[fila][columna] = ' ';

  // Si hay una o mas minas adyacentes, poner el numero de minas en la casilla
  } else {
    tablero[fila][columna] = numeroMinas.toString();
  }

  // Si la casilla no tiene minas alrededor, descubrir sus 8 adyacentes
  if (numeroMinas == 0) {
      
    // Ir moviendose por las filas adyacentes
    for (
      int desplazamientoFila = -1;
      desplazamientoFila <= 1;
      desplazamientoFila++
    ) {
        
      // Ir moviendose por las columnas adyacentes
      for (
        int desplazamientoColumna = -1;
        desplazamientoColumna <= 1;
        desplazamientoColumna++
      ) {
          
        // Llamar a esta misma funcion para repetir 
        // el proceso con todas las casillas adyacentes
        destaparCasilla(
          tablero,
          minas,
          fila + desplazamientoFila,
          columna + desplazamientoColumna,
          false,
          false,
        );
      }
    }
  }

  // Si no ha habido ninguna explosion en todo el proceso,
  // devolver false indicando que no ha explotado ninguna mina
  return false;
}

// Funcion por si la primera posicion seleccionada es una mina, cambiarla de ubicacion
void moverMina(
  List<List<bool>> minas,
  int fila,
  int columna,
) {

  // Eliminar la mina de la posicion original
  minas[fila][columna] = false;

  // Variables para comprobar el cuadrante de la bomba que se movera
  int filaInicio;
  int filaFin;
  int columnaInicio;
  int columnaFin;

  // Comprobacion del cuadrante de la fila
  // Arriba
  if (fila < 3) {
    filaInicio = 0;
    filaFin = 3;
  //Abajo
  } else {
    filaInicio = 3;
    filaFin = 6;
  }

  // Comprobacion del cuadrante de la columna
  // Izquierda
  if (columna < 5) {
    columnaInicio = 0;
    columnaFin = 5;
  // Derecha
  } else {
    columnaInicio = 5;
    columnaFin = 10;
  }

  // Crear el generador de numeros y las variables con la nueva posicion de la mina
  Random random = Random();
  int nuevaFila;
  int nuevaColumna;

  // Bucle para conseguir la nueva posicion de la mina
  do {
    // Conseguir una posicion al azar dentro del tablero, 
    // determinada por el cuadrante de la mina original
    nuevaFila = filaInicio + random.nextInt(filaFin - filaInicio);
    nuevaColumna = columnaInicio + random.nextInt(columnaFin - columnaInicio);

  // Repetir el proceso hasta encontrar una casilla que este libre
  } while (
    minas[nuevaFila][nuevaColumna]
  );

  // Cuando encuentre una que este libre, coloca alli la mina
  minas[nuevaFila][nuevaColumna] = true;
}

// Metodo para poner o quitar banderas del tablero
void gestionarBandera(
  List<List<String>> tablero,
  int fila,
  int columna,
) {

  // Si no habia una bandera marcada en la casilla, cambiar esa casilla a una bandera
  if (tablero[fila][columna] == '·') {
    tablero[fila][columna] = '#';

  // Si habia una bandera marcada en la casilla, cambiar esa bandera a una casilla normal
  } else if (tablero[fila][columna] == '#') {
    tablero[fila][columna] = '·';
  }
}

// Funcion para leer la accion que quiere ejecutar el usuario
void leerComando() {

  // Texto de entrada
  print('Introduce un comando:');

  // Leer el texto que ponga el usuario
  String? entrada = stdin.readLineSync();

  // Si no hay nada en la entrada, no hacer nada
  if (entrada == null) {
    return;
  }

  // Procesar el texto que ha introducido el usuario,
  // 1. trim() quita los espacios al principio y final
  // 2. toLowerCase() combierte toda la entrada a minusculas
  entrada = entrada.trim().toLowerCase();

  if (entrada == 'cheat' || entrada == 'trampes') {
    print('Has escrito el comando cheat');
  } else if (entrada == 'help' || entrada == 'ajuda') {
    print('Has escrito el comando help');
  } else {
    List<String> partes = entrada.split(' ');
  }
}