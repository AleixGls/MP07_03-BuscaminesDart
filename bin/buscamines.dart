import 'dart:math';
import 'dart:io';



void main(List<String> arguments) {

  // Constantes del tablero
  const int filas = 6;
  const int columnas = 10;
  const int totalMinas = 8;
  


  // Generar el tablero
  // Generar la lista principal(Matriz) que sera el tablero
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