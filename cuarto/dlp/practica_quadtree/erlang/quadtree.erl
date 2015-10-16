
%% -*- coding: utf-8 -*-
%% @author Adrian Insua y Aaron Montero
%% @version 1.
%% @doc Este modulo es una emulacion del quadtree.java que contiene la clase main
-module(quadtree).
-export([main/6]).
-import(parser, [parser/1]).
-import(nodo, [start/1, analizar/1]).

%% @doc Función principal e interfaz del programa
%% @spec main(string(),boolean(),boolean(),boolean(),boolean(),boolean())->any()
main("",_,_,_,_,_) -> {error, file_text_not_found}; %% error si no se especifica ruta
main(File, P, C, Pa, D, Pd) ->
    {Dim, Imagen} = parser:parser(File),
    Arbol = nodo:start(Imagen, Dim),
    nodo:setHoja(Arbol),
    comprobarP(P, Imagen, Dim),
    comprobarC(C, Arbol),
    comprobarPa(Pa, Arbol),
    Desc = comprobarD(D, Arbol),
    comprobarPd(Pd, Desc,Dim),
    nodo:stop(Arbol).

%%funciones privadas del modulo

%%impresion
comprobarP(false,_,_) -> io:format("No se imprime el arbol ~n");
comprobarP(true, Arbol, Dim) -> for(0,0, Dim, Arbol).

%%Codificación
comprobarC(false,_) -> io:format("No se codifica el arbol ~n");
comprobarC(true, Nodo) -> 
    ListaHijos = nodo:analizar(Nodo),
    if
        (length(ListaHijos) =:= 0) -> ok; %%si el nodo a analizar es hoja no tendrá hijos
        true -> 
            %%se mapea la funcion comprobarC de forma recurrente a todos los hijos
            lists:map(fun(X) -> comprobarC(true,X) end, ListaHijos) 
    end.

%%Impresion arbol codificado
comprobarPa(false,_) -> skipping_print_quad;
comprobarPa(true, Arbol) -> 
    %%El arbol se codifica como un string
    Res = nodo:imprimir(Arbol),
    imprimir(Res), io:format("~n").

%%Funcion para imprimir el string (lista de caracteres) adaptada a erlang
imprimir([]) -> io:format("");
imprimir([[]|T]) -> imprimir(T);
imprimir([H|T]) when is_list(H) ->
    imprimir(H), imprimir(T);
imprimir([H|T]) ->
    io:format("~c",[H]), imprimir(T);
imprimir(H) -> io:format("~c",[H]).

%%Descodificación
comprobarD(false,_) -> skipping_decode;
comprobarD(true, Arbol) -> 
   Res= nodo:descodificar(Arbol),
   Res.

%%Impresión descodificación
comprobarPd(false,_,_) -> skipping_print_decode;
comprobarPd(true,Arbol,Dim) -> io:format("~nArbol descodificado:~n"),for(0,0,Dim, Arbol).

%%For adaptado a erlang
%%  Inti = contador primer for, filas
%%  Intj = contador segundo for, columnas
%%  Dim  = finalización for, para este problema es la misma para los dos for
%%  Imagen = datos a imprimir
%%
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
