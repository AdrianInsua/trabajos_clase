
%% -*- coding: utf-8 -*-
%% @author Adrian Insua y Aaron Montero
%% @version 1.
%% @doc Este modulo es una emulacion de la clase Nodo
-module(nodo).
-export([start/0, start/2]). %%constructores
-export([setDatos/2, setHoja/1]). %%setters
-export([getDatos/1, getHoja/1]). %%getters
-export([nodoClase/4]). %%clase
-export([stop/1]).
-export([analizar/1, imprimir/1, descodificar/1]). %%metodos de clase

%% @doc Constructor vacio, no se usa
start() -> %%Constructor vacio
    Pid = spawn(fun init/0),
    Pid.

%% @doc Inicializa un proceso nodo, es decir un objeto de la clase nodo
%% @spec start(array(),integer())->pid()
start(Datos, Dim) -> %%Constructor con datos y dimension
    Pid = spawn(?MODULE, nodoClase, [Datos, true, [], Dim]),
    Pid.

%% @doc Detiene todos los procesos nodos relacionados a ese pid
%% @spec stop(pid()) -> atom()
stop(Nodo) ->
    Nodo ! stop.

%%funcion privada para el constructor vacio
init() -> nodoClase([], true, [], nil).

%% @doc Metodo setter de datos
%% @spec setDatos(pid(),array())->any()
setDatos(Nodo, Datos) ->
    Nodo ! {setDatos, Datos}.

%% @doc Comprueba si el nodo con pid Nodo es hoja
%% @spec setHoja(pid())-> any()
setHoja(Nodo) ->
    Nodo ! setHoja.

%% @doc Devuelve el valor de hoja del nodo
%% @spec getHoja(pid()) -> boolean()
getHoja(Nodo) ->
    Nodo ! {getHoja, self()},
    receive
        Valor -> Valor
    end.

%% @doc Getter del valor de los datos del nodo Nodo
%% @spec getDatos(pid()) -> array()
getDatos(Nodo) ->
    Nodo ! {getDatos,self()},
    receive
        {ok, Datos} -> Datos
    end.

%%  @doc Metodo de la clase nodo, que realiza la subdivisión en cuadrantes
%%  @spec analizar(pid()) -> list()
analizar(Nodo) ->
    Nodo ! {analizar,self()},
    receive
        {ok,ListaHijos} -> 
            ListaHijos;
        {error, fin_lista} -> [] %% Si analizamos una hoja como primer elemento entrará por aqui
    end.

%% @doc Metodo de la clase nodo que devuelve el string con el arbol parentizado
%% @spec imprimir(pid()) -> list()
imprimir(Nodo) ->
    Nodo ! {imprimir,self()},
    receive
        Res -> Res
    end.

%% @doc Metodo de la clase nodo que devuelve un array con el arbol descodificado
%% @spec descodificar(pid()) -> array()
descodificar(Nodo) ->
    Nodo ! {descodificar, self()},
    receive
        Res -> Res
    end.

%%loop que actuara como objeto de la clase nodo, los argumentos son las variables de la clase
%% @doc Metodo interno de la clase, se exporta para igualar la construccion a java
nodoClase(Datos, Hoja, Hijos, Dim) ->
    receive
        {setDatos, Datos} -> 
            nodoClase(Datos, Hoja, Hijos, Dim);
        setHoja ->
            Aux = array:get(0,Datos),
            Valor = sethoja(0,0,Dim,Datos,array:get(0,Aux)),
            nodoClase(Datos, Valor, Hijos, Dim);
        {getDatos, From} -> 
            From ! {ok, Datos},
            nodoClase(Datos, Hoja, Hijos, Dim);
        {getHoja, From} ->
            From ! Hoja,
            nodoClase(Datos, Hoja, Hijos, Dim);
        {analizar, From} ->
            if
                Hoja == false -> %%Si el primer elemento no es hoja analizaremos sus cuadrantes
                    Sep = trunc(Dim/2),
                    ArrayHijos = forji(0,0, Dim, Sep, Datos, lists:map(fun(_) -> array:new(Sep) end,[[],[],[],[]]), lists:map(fun(_) -> array:new(Sep) end, [[],[],[],[]])),

                    %%ahora crearemos los nuevos procesos nodo

                    Cuad1 = spawn(?MODULE, nodoClase, [array:get(0,ArrayHijos), true, [], Sep]),
                    setHoja(Cuad1),
                    Cuad2 = spawn(?MODULE, nodoClase, [array:get(1,ArrayHijos), true, [], Sep]),
                    setHoja(Cuad2),
                    Cuad3 = spawn(?MODULE, nodoClase, [array:get(2,ArrayHijos), true, [], Sep]),
                    setHoja(Cuad3),
                    Cuad4 = spawn(?MODULE, nodoClase, [array:get(3,ArrayHijos), true, [], Sep]),
                    setHoja(Cuad4),
                    From ! {ok, [Cuad1,Cuad2,Cuad3,Cuad4]},
                    nodoClase(nil, Hoja, [Cuad1,Cuad2,Cuad3,Cuad4], Dim);
                true ->
                    From ! {error, fin_lista},
                    nodoClase(Datos, Hoja, Hijos, Dim)
            end;
         {imprimir, From} ->
            Res = imprimirArbol(Datos, Hijos, Hoja),
            From ! Res,
            nodoClase(Datos, Hoja, Hijos,Dim);
         {descodificar, From} ->
            Res = forijDesco(0,0,Hoja,Dim,Hijos,Datos,array:new(Dim),array:new(Dim)),
            From ! Res,
            nodoClase(Datos, Hoja, Hijos, Dim);
          stop ->
                lists:map(fun(X) -> nodo:stop(X) end, Hijos)
    end.

%% comprueba si todos los datos son iguales
sethoja(Inti,Intj,Dim,Datos,Control) ->
    case Inti < Dim of
        true ->
            case Intj < Dim of
                true ->
                    Fila = array:get(Inti,Datos),
                    Dato = array:get(Intj,Fila),
                    if
                        Dato =/= Control -> false;
                        true -> sethoja(Inti,Intj+1,Dim,Datos,Control)
                    end;
                false -> sethoja(Inti+1,0,Dim,Datos,Control)
            end;
        false -> true
    end.
            
%%Concatena la impresion del arbol parentizado
imprimirArbol(Datos, Hijos, Hoja) ->
    case Hoja of
        true -> Res = array:get(0,array:get(0,Datos));
        false -> Res = "node"++ (lists:map(fun(X) -> imprimir(X) end, Hijos))
    end,
    lists:concat([[40],[Res],[41]]).

%%Emulamos un for anidado mediante recursividad para que se parezca a la version original en Java
forji(Inti, Intj, Dim, Sep, Datos,[C1,C2,C3,C4],[Ac1,Ac2,Ac3,Ac4]) ->
    case Inti < Dim of
        true ->
            Fila = array:get(Inti,Datos),
            case Intj < Dim of
                true -> 
                    Dato = array:get(Intj,Fila),
                    if 
                        (Inti < Sep) and (Intj < Sep) -> forji(Inti, Intj+1, Dim, Sep, Datos, [array:set(Intj,Dato,C1),C2,C3,C4] ,[Ac1,Ac2,Ac3,Ac4]);
                        (Inti < Sep) and (Intj >= Sep) -> forji(Inti, Intj+1, Dim, Sep, Datos, [C1, array:set(Intj rem Sep,Dato,C2),C3,C4],[Ac1,Ac2,Ac3,Ac4]);
                        (Inti >= Sep) and (Intj < Sep) -> forji(Inti, Intj+1, Dim, Sep, Datos, [C1,C2,array:set(Intj,Dato,C3),C4],[Ac1,Ac2,Ac3,Ac4]);
                        true -> forji(Inti, Intj+1, Dim, Sep, Datos, [C1,C2,C3,array:set(Intj rem Sep,Dato,C4)],[Ac1,Ac2,Ac3,Ac4])
                    end;
                false -> 
                        NuevosC = lists:map(fun(_) -> array:new(Sep) end, [[],[],[],[]]),
                        if
                            Inti < Sep -> forji(Inti+1,0,Dim,Sep,Datos,NuevosC, [array:set(Inti,C1,Ac1),array:set(Inti,C2,Ac2),Ac3,Ac4]);
                            true -> forji(Inti+1,0,Dim,Sep,Datos,NuevosC, [Ac1,Ac2,array:set(Inti rem Sep,C3,Ac3),array:set(Inti rem Sep,C4,Ac4)])
                        end
            end;
        false -> 
            Aux = array:new(4),
            %%dado que erlang no permite la sobreescritura de variables necesitamos una funcion auxiliar 
            %%que vaya guardando en aux los nuevos valores del array
            guardarAcc(Aux,[Ac1,Ac2,Ac3,Ac4], 0) 
    end.

guardarAcc(Aux,[],_) -> Aux;
guardarAcc(Aux,[H|T], Pos) ->
   guardarAcc(array:set(Pos,H,Aux),T,Pos+1).


%%Emulación del bucle for de descodificacion
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
            %%Si es un nodo se analizan sus cuatro hijos por separado
            C1 = nodo:descodificar(lists:nth(1,Hijos)),    
            C2 = nodo:descodificar(lists:nth(2,Hijos)),    
            C3 = nodo:descodificar(lists:nth(3,Hijos)),    
            C4 = nodo:descodificar(lists:nth(4,Hijos)),    
            componer(0,0,Dim,C1,C2,C3,C4,array:new(Dim),array:new(Dim))
    end.

%%auxiliar de descodificacion para mejorar la compresion de la funcion anterior
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
