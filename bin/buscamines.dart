import 'dart:math';

void main(List<String> arguments) {

  // Constantes del tablero
  const int filas = 6;
  const int columnas = 10;
  const int totalMinas = 8;
  


  // Generar el tablero
  // Generar la lista principal que sera el tablero
  List<List<String>> tablero = List.generate(

    // Generar las listas que seran las filas dentro de la lista principal
    filas,
    (_) => List.generate(

      // Generar los strings que seran las columnas dentro de las filas
      columnas, 
      (_) => '·'
    ),
  ); 


  // Generar la matriz de minas vacias
  List<List<bool>> minas = List.generate(
    filas,
    (_) => List.generate(columnas, (_) => false),
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


  print(tablero);
}

// Funcion para colocar las minas por los cuadrantes del tablero
void colocarMinas(
  List<List<bool>> minas,
  int filaInicio,
  int filaFin,
  int columnaInicio,
  int columnaFin,
) {
  Random random = Random();

  int colocadas = 0;

  while (colocadas < 2) {
    int fila = filaInicio + random.nextInt(filaFin - filaInicio);
    int columna = columnaInicio + random.nextInt(columnaFin - columnaInicio);

    if (!minas[fila][columna]) {
      minas[fila][columna] = true;
      colocadas++;
    }
  }
}