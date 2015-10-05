
Esta practica consiste en la realización de un arbol del tipo QuadTree

Se dispone de un archivo de texto cuya primera linea sera la dimension de la matriz de datos (la dimesion será = 2^n, siendo n el número de esta linea)
Cada nodo se dividira en cuatro hijos, estos hijos seran hoja si son monocromo, es decir todos sus datos son del mismo tipo. En caso contrario se
continuara con la división de los hijos.

El programa requiere de un proceso de impresion de datos, codificación, impresión de quadtree en forma parentesica, decodificación del quadtree generado e impresión de la decodificación.

El control de estos procesos se realiza mediante el paso de argumentos en la ejecución siendo estos parametros los siguientes:
   -f = direccion del archivo con la matriz de datos
   -p = imprime por pantalla la imagen
   -c = codificacion
   -pa = imprime el arbol codificado
   -d = decodifica el arbol obtenido
   -pd = imprime el arbol decodificado
