
PRACTICA QUADTREE
=======================
##Principal realizada en java

###Contextualización

Compilador: Netbeans So: Ubuntu 14.14

Lenguaje usado: Java, lenguaje tipico de orientación a objetos que se puede ejecutar independientemente de la arquitectura de la maquina en la que se ejecute gracias al uso de su maquina virtual.

Java utiliza memoria heap donde se almacenan las variables creadas con `new(..)`, esta memoria es dinamica e irá creciendo según sea necesario, sin embargo la JVM dispone de un sistema de optimización que almacena variables que se ejecuten en un solo thread o metodo en la memoria stack. Además de esto java posee un garbage collector que va elminando las variables no usadas de la memoria heap.

####Ventajas y desventajas
La posibilidad de usar clases para realizar codigo independiente y bien estructurado facilita las labores de programación, en este caso podemos diferenciar los trabajos de parsear el archivo en una clase, la api externa en otra, y cada uno de los nodos que se crearan serán otro objeto de la clase Nodo.

Ademas la posibilidad de uso de memoria dinamica facilita la creación de los hijos, no tendremos que preocuparnos de calcular cuantos tendrá el siguiente nivel si recorremos el arbol en anchura, usando un ArrayList, solo tenemos que añadirlo y el array aumentará automaticamente.

Es un lenguaje simple que no requiere demasiado control del tipado de datos, por ejemplo a la hora de hacer una impresion con un println, como veremos mas adelante en otros lenguajes como erlang puede ser más costoso

###Explicación breve del codigo

Esta practica consiste en la realización de un arbol del tipo **QuadTree**

Se dispone de un archivo de texto cuya primera linea sera la dimension de la matriz de datos (la dimesion será = 2^n, siendo n el número de esta linea)
Cada nodo se dividira en cuatro hijos, estos hijos seran hoja si son monocromo, es decir todos sus datos son del mismo tipo. En caso contrario se
continuara con la división de los hijos.

El programa requiere de un proceso de impresion de datos, codificación, impresión de quadtree en forma parentesica, decodificación del quadtree generado e impresión de la decodificación.

El control de estos procesos se realiza mediante el paso de argumentos en la ejecución siendo estos parametros los siguientes:
   - f = direccion del archivo con la matriz de datos
   - p = imprime por pantalla la imagen
   - c = codificacion
   - pa = imprime el arbol codificado
   - d = decodifica el arbol obtenido
   - pd = imprime el arbol decodificado

El proceso de impresion de arbol parentizado se hace de forma "recursiva", y la descomposición de los hijos de forma similar, de este modo debería ser más facil implementar el algoritmo en lenguajes como erlang

####Problemas encontrados

En el proceso de **codificación** realizado en el main, la igualcion de ArrayList asocia los datos en memoria, por lo que al borrarlos de la variable auxiliar se eliminan también en la original. A continuación se muestra un ejemplo del código afectado:
```
hijos = (ArrayList) quadTree.analizar().clone();
      while (hijos.size() > 0) {
          nuevosHijos.clear();
```

Como se puede apreciar se ha utilizado el metodo clone, para crear copias en otra posicion de memoria.

##ADAPTACIÓN EN ERLANG

###Contextualización

Version: erl v5.10.4 OS:ubuntu 14.14

Erlang es un lenguaje funcional orientado a la concurrencia, muy usado en sistemas con alta escalibilidad y sistemas distribuidos, ya que la creación de procesos es muy sencilla en este lenguaje, además como caracteristicas importantes cabe destacar su tolerancia a fallos, y la posibilidad de realizar cambios de codigo en caliente, debido a esto es común su uso en aplicaciones de telefonía con un gran volumen de datos.

Erlang ofrece seguridad en cuanto a la opacidad de su código debido a que cada modulo solo tendrá visibles y se comunicará mediante las funciones exportadas por el mismo.

Al igual que java, erlang se ejecuta en una maquina virtual por lo que se puede ejecutar en cualquier sitema, y dispone de garbage collector para eliminar las variables desrefenciadas.

En cuanto a la gestion de memoria se pueden crear listas dinamicas como en otros lenguajes concurrentes, vease Ocaml, o arrays dinamicos, sin embarjo cuando se le asigna un valor a una variable dentro de un metodo este no se puede sobreescribir, tendriamos que realizar una llamada concurrente enviando al metodo el nuevo valor de la variable como argumento del mismo.

###Ventajas y desventajas

Aunque erlang no sea un lenguaje orientado a objetos puro podemos usar los procesos a modo de objetos de clase, estos se quedaran escuchando en segundo segundo plano, hasta que otro proceso les envíe un mensaje.

Los constructores se emularán mediante los metodos start de los procesos.

Cada proceso tendrá una serie de valores de recepción que serán los metodos de la clase, por lo que si queremos crear metodos públicos solo tenemos que exportar la función como api publica del modulo.

Cada proceso será una función loop que recibirá una serie de argumentos, estos argumentos serán considerados como las variables de la clase.

Sin embargo erlang por ser tipicamente concurrente carece de bucles for, lo que nos ha obligado a emularlos con metodos con conteo de incrementación, variables de acumulación. Estos fors no resultan portables, ya que cada metodo realiza solo la función especifica para la que fue creado

En cuanto a la impresión erlang es más especifico que java, y requiere tener mayor conocimiento sobre el tipo de dato que se va a imprimir, lo cual en ciertas ocasiones nos ha dado algún problema.

###Justificaciones

Hemos realizado una adaptación leve en la concatenación del arbol parentizado utilizando los codigos ascii de los parentesis, ya que erlang codifica los caracteres como asciis en las listas.

Los hijos se guardan en una lista ya que es un array de una sola dimension, y el uso de arrays da problemas al usar la funcion array:map, debido a la devolución si se analiza un nodo hoja.
```
analizar(Nodo) ->
    Nodo ! {analizar,self()},
    receive
        {ok,ListaHijos} -> 
            ListaHijos;
        {error, fin_lista} -> [] %% Si analizamos una hoja como primer elemento entrará por aqui
    end.
```

Como ya se ha dicho se han tenido que crear bucles for mediante funciones privadas, que ejecutan solo el código para el que han sido programados.

```
for(Inti, Intj, Dim, Imagen) ->
    case Inti < Dim of
        true ->
            Fila = array:get(Inti,Imagen),
            case Intj < Dim of
                true ->
                    Dato = array:get(Intj,Fila),
                    io:format("~c", [Dato]),
                    for(Inti,Intj+1,Dim,Imagen);
                false ->     
                    io:format("~n"),
                    for(Inti+1,0,Dim,Imagen)
            end;
        false ->
            io:format("~n")
    end.
```
Los objetos nodos serán procesos en bucle:
```
nodoClase(Datos, Hoja, Hijos, Dim) ->
    receive
        {setDatos, Datos} -> 
            nodoClase(Datos, Hoja, Hijos, Dim);
        setHoja ->
            Aux = array:to_list(Datos),
            Valor = sethoja(lists:map(fun(X) -> array:to_list(X) end, Aux)),
            nodoClase(Datos, Valor, Hijos, Dim);
        {getDatos, From} -> 
            From ! {ok, Datos},
            nodoClase(Datos, Hoja, Hijos, Dim);
        {getHoja, From} ->
            From ! Hoja,
            nodoClase(Datos, Hoja, Hijos, Dim);
        {analizar, From} ->
            if
                Hoja == false ->
                    Sep = trunc(Dim/2),
                    ArrayHijos = forji(0,0, Dim, Sep, Datos, lists:map(fun(_) -> array:new(Sep) end,[[],[],[],[]]), lists:map(fun(_) -> array:new(Sep) end, [[],[],[],[]])),
                    Cuad1 = spawn(?MODULE, nodoClase, [array:get(0,ArrayHijos), true, [], Sep]),
                    setHoja(Cuad1),
                    Cuad2 = spawn(?MODULE, nodoClase, [array:get(1,ArrayHijos), true, [], Sep]),
                    setHoja(Cuad2),
                    Cuad3 = spawn(?MODULE, nodoClase, [array:get(2,ArrayHijos), true, [], Sep]),
                    setHoja(Cuad3),
                    Cuad4 = spawn(?MODULE, nodoClase, [array:get(3,ArrayHijos), true, [], Sep]),
                    setHoja(Cuad4),
                    From ! {ok, [Cuad1,Cuad2,Cuad3,Cuad4]},
                    nodoClase(Datos, Hoja, [Cuad1,Cuad2,Cuad3,Cuad4], Dim);
                true ->
                    From ! {error, fin_de_arbol},
                    nodoClase(Datos, Hoja, Hijos, Dim)
            end;
         {imprimir, From} ->
            Res = imprimirArbol(array:get(0,Datos), Hijos, Hoja),
            From ! Res,
            nodoClase(Datos, Hoja, Hijos,Dim);
         {descodificar, From} ->
            Res = forijDesco(0,0,Hoja,Dim,Hijos,Datos,array:new(Dim),array:new(Dim)),
            From ! Res,
            nodoClase(Datos, Hoja, Hijos, Dim)
    end.
```

Para la creacion de arrays se ha utilizado el modulo array de erlang, en lugar de listas, ya que este permite sustituir valores mediante set y get, al igual que el ArrayList de java.

Algunas funciones han tenido que dividirse en una principal y una auxiliar, para facilitar su comprensión, ya que la mezcla de la naturaleza concurrente del lenguaje y la adaptación de los bucles for, provacaría tener unas cabeceras de función excesivamente extensas, como es el caso de la siguiente función:
```
forijDesco(Inti, Intj, Hoja, Dim,Hijos, Datos,Deco, DecoAcc)->
    case Hoja of
        true -> 
            case Inti < Dim of
                true ->
                    case Intj < Dim of
                        true ->
                            Fila = array:get(0,Datos),
                            Dato = array:get(0,Fila),
                            forijDesco(Inti, Intj+1,Hoja,Dim,Hijos,Datos,array:set(Intj,Dato,Deco),DecoAcc);
                        false -> forijDesco(Inti+1,0,Hoja,Dim,Hijos,Datos,array:new(Dim),array:set(Inti,Deco,DecoAcc))
                    end;
                false -> DecoAcc
            end;
        false ->
            C1 = nodo:descodificar(lists:nth(1,Hijos)),    
            C2 = nodo:descodificar(lists:nth(2,Hijos)),    
            C3 = nodo:descodificar(lists:nth(3,Hijos)),    
            C4 = nodo:descodificar(lists:nth(4,Hijos)),    
            componer(0,0,Dim,C1,C2,C3,C4,array:new(Dim),array:new(Dim))
    end.

componer(Inti,Intj,Dim,C1,C2,C3,C4,Res,ResAcc) ->
    Sep = trunc(Dim/2),
    case Inti < Dim of
        true ->
            case Intj < Dim of
                true ->
                    if
                        Inti < Sep -> Fila1 = array:get(Inti, C1), Fila2 = array:get(Inti, C2);
                        true -> Fila1 = array:get(Inti rem Sep, C3), Fila2 = array:get(Inti rem Sep, C4)
                    end,
                    if
                        (Inti<Sep) and (Intj<Sep) ->
                               componer(Inti,Intj+1,Dim,C1,C2,C3,C4,array:set(Intj, array:get(Intj,Fila1),Res),ResAcc);
                        (Inti<Sep) and (Intj>=Sep) -> componer(Inti,Intj+1,Dim,C1,C2,C3,C4,array:set(Intj, array:get(Intj rem Sep, Fila2),Res),ResAcc);
                        (Inti>=Sep) and (Intj<Sep) -> componer(Inti,Intj+1,Dim,C1,C2,C3,C4,array:set(Intj, array:get(Intj,Fila1),Res),ResAcc);
                        true -> componer(Inti,Intj+1,Dim,C1,C2,C3,C4,array:set(Intj,array:get(Intj rem Sep, Fila2),Res),ResAcc)
                    end;
                false ->
                    componer(Inti+1,0,Dim,C1,C2,C3,C4,array:new(Dim),array:set(Inti,Res,ResAcc))
            end;
        false ->  ResAcc
    end.
```

El proceso es el mismo que en java pero la fusión de las dos funciones sumaria todos los argumentos de la segunda menos `Inti` e `Intj` a la primera.


Se ha creado una funcion stop() para parar los procesos tras su ejecución ya que como no es proyecto que se vaya a seguir utilizando es un gasto innecesario de memoria

###Desaprovechamientos del lenguaje
La realización de la práctica se podría optimizar no solo obviando los fors, y utilizando concurrencia puramente, si no también evitando el uso de arrays, ya que estos en erlang se crean del modo pares {Clave,Valor} lo cual ocupa más en memoría que simples atomos que usarian las listas, además por defecto erlang crea arrays de 10 celdas, aunque se le especifique un valor menor, lo cual es un gasto de memoria innecesario.

En cuanto a velocidad de acceso también se ha comprobado que es mucho mas eficaz el acceso a datos utilizando listas que utilizando arrays, los datos se encuentran en la siguiente página:

(http://www.jkdrkn.livejournal.com/240948.html)

Por lo que realizando procesos concurrentes puros que usaran listas, ganariamos en velocidad y espacio en memoria

 
