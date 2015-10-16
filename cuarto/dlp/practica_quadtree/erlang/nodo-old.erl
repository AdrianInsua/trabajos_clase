-module(nodo).
-export([start/0, start/2]). %%constructores
-export([setDatos/2, setHoja/1]). %%setters
-export([getDatos/1, getHoja/1]). %%getters
-export([nodoClase/4]). %%clase
-export([analizar/1, imprimir/1, descodificar/1, desco/1]). %%metodos de clase

start() -> %%Constructor vacio
    Pid = spawn(fun init/0),
    Pid.

start(Datos, Dim) -> %%Constructor con datos y dimension
    Pid = spawn(?MODULE, nodoClase, [Datos, true, [], Dim]),
    Pid.

init() -> nodoClase([], true, [], nil).

setDatos(Nodo, Datos) ->
    Nodo ! {setDatos, Datos}.

setHoja(Nodo) ->
    Nodo ! setHoja.

getHoja(Nodo) ->
    Nodo ! {getHoja, self()},
    receive
        Valor -> Valor
    end.

getDatos(Nodo) ->
    Nodo ! {getDatos,self()},
    receive
        {ok, Datos} -> Datos
    end.

analizar(Nodo) ->
    Nodo ! {analizar,self()},
    receive
        {ok,ListaHijos} -> 
            ListaHijos;
        {error, fin_de_arbol} -> []
    end.

imprimir(Nodo) ->
    Nodo ! {imprimir,self()},
    receive
        Res -> Res
    end.

descodificar(Nodo) ->
    Nodo ! {descodificar, self()},
    receive
        Res -> Res
    end.
desco(Nodo) ->
    Nodo ! {descAux, self()},
    receive
        Res -> Res
    end.

nodoClase(Datos, Hoja, Hijos, Dim) ->
    receive
        {setDatos, Datos} -> 
            nodoClase(Datos, Hoja, Hijos, Dim);
        setHoja ->
            Valor = sethoja(Datos),
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
                    [C1,C2,C3,C4] = forji(1, 1, Dim + 1, trunc((Dim/2) +1), Datos, [[],[],[],[]],[[],[],[],[]]),
                    Cuad1 = spawn(?MODULE, nodoClase, [C1, true, [], trunc(Dim/2)]),
                    setHoja(Cuad1),
                    Cuad2 = spawn(?MODULE, nodoClase, [C2, true, [], trunc(Dim/2)]),
                    setHoja(Cuad2),
                    Cuad3 = spawn(?MODULE, nodoClase, [C3, true, [], trunc(Dim/2)]),
                    setHoja(Cuad3),
                    Cuad4 = spawn(?MODULE, nodoClase, [C4, true, [], trunc(Dim/2)]),
                    setHoja(Cuad4),
                    From ! {ok, [Cuad1,Cuad2,Cuad3,Cuad4]},
                    nodoClase(Datos, Hoja, [Cuad1,Cuad2,Cuad3,Cuad4], Dim);
                true ->
                    From ! {error, fin_de_arbol},
                    nodoClase(Datos, Hoja, Hijos, Dim)
            end;
         {imprimir, From} ->
            Res = imprimirArbol(lists:flatten(Datos), Hijos, Hoja),
            From ! Res,
            nodoClase(Datos, Hoja, Hijos,Dim);
         {descodificar, From} ->
            Res = forijDesco(1,1,Hoja,Dim+1,Hijos,Datos,[],[]),
            io:format("~w~n",[Res]),
            From ! Res,
            nodoClase(Datos, Hoja, Hijos, Dim);
         {descAux,From} ->
            Res = forijDesco(1,1,Hoja,Dim+1,Hijos,Datos,[],[]),
            io:format("~w~n",[Res]),
            From ! Res,
            nodoClase(Datos,Hoja,Hijos,Dim)
    end.

%% @doc sethoja/1, comprueba que todos los datos del nodo son iguales mediante list comprehension
sethoja(Datos) ->
    DatosPlanos = lists:flatten(Datos),
    %%las comprobaciones se realizan con el caracter ascii por comodidad
    Alm = [X || X <- DatosPlanos, X =/= 46],
    Punt = [X || X <- DatosPlanos, X =/= 35],
    (Alm == []) or (Punt == []). %%Si no hay puntos o no hay almohadillas devolverá true

imprimirArbol(Datos, Hijos, Hoja) ->
    case Hoja of
        true -> Res = lists:nth(1,Datos);
        false -> Res = "node"++ (lists:map(fun(X) -> imprimir(X) end, Hijos))
    end,
    lists:concat([[40],[Res],[41]]).

%%Emulamos un for anidado mediante recursividad para que se parezca a la version original en Java
forji(Inti, Intj, Dim, Sep, Datos, [C1,C2,C3,C4], [Ac1,Ac2,Ac3,Ac4]) ->
    case Inti == Dim of
        false ->
            Fila = lists:nth(Inti, Datos),
            case Intj == Dim of
                false -> 
                    Dato = lists:nth(Intj, Fila),
                    if 
                        (Inti < Sep) and (Intj < Sep) -> forji(Inti, Intj+1, Dim, Sep, Datos, [[Dato|C1],C2,C3,C4],[Ac1,Ac2,Ac3,Ac4]);
                        (Inti < Sep) and (Intj >= Sep) -> forji(Inti, Intj+1, Dim, Sep, Datos, [C1,[Dato|C2],C3,C4],[Ac1,Ac2,Ac3,Ac4]);
                        (Inti >= Sep) and (Intj < Sep) -> forji(Inti, Intj+1, Dim, Sep, Datos, [C1,C2,[Dato|C3],C4],[Ac1,Ac2,Ac3,Ac4]);
                        true -> forji(Inti, Intj+1, Dim, Sep, Datos, [C1,C2,C3,[Dato|C4]],[Ac1,Ac2,Ac3,Ac4])
                    end;
                true -> forji(Inti+1,1,Dim,Sep,Datos,[[],[],[],[]], [[lists:reverse(C1)]++Ac1,[lists:reverse(C2)]++Ac2,[lists:reverse(C3)]++Ac3,[lists:reverse(C4)]++Ac4])
            end;
        true -> 
           ListaSinVacios = lists:map(fun(X) -> [Y || Y <- X, Y =/= []] end,[Ac1,Ac2,Ac3,Ac4]),
           lists:map(fun(X) -> lists:reverse(X) end, ListaSinVacios)
    end.

forijDesco(Inti, Intj, Hoja, Dim,Hijos, Datos,Deco, DecoAcc)->
    case Hoja of
        true -> 
            Dato = lists:nth(1,Datos),
            case Inti == Dim of
                false ->
                    case Intj == Dim of
                        false -> forijDesco(Inti, Intj+1,Hoja,Dim,Hijos,Datos,[Dato|Deco],DecoAcc);
                        true -> forijDesco(Inti+1,Intj,Hoja,Dim,Hijos,Datos,[],[Deco]++DecoAcc)
                    end;
                true -> DecoAcc
            end;
        false ->
            C1 = nodo:desco(lists:nth(1,Hijos)),    
            C2 = nodo:desco(lists:nth(2,Hijos)),    
            C3 = nodo:desco(lists:nth(3,Hijos)),    
            C4 = nodo:desco(lists:nth(4,Hijos)),    
            ListaPlana = lists:map(fun(X) -> lists:flatten(X) end, [C1,C2,C3,C4]),
            ListaPlana
    end.


componer([C1,C2,C3,C4],Sep) ->
    {L11,L21} = lists:split(Sep,C1),
    {L12,L22} = lists:split(Sep,C2),
    {L31,L41} = lists:split(Sep,C3),
    {L32,L42} = lists:split(Sep,C4),
    [L11++L12,L21++L22,L31++L32,L41++L42].

%%descoAux(Inti,Intj,Dim,Sep,C1,C2,C3,C4,Deco,DecoAcc) ->
%%    case Inti == Dim of
%%        false ->
%%            case Intj == Dim of 
%%                false ->
%%                    if
%%                        (Inti < Sep) and (Intj < Sep) -> 
%%                            Dato = lists:nth(Intj,lists:nth(Inti,C1)),
%%                            descoAux(Inti,Intj+1,Dim,Sep,C1,C2,C3,C4,[Dato|Deco],DecoAcc);
%%                        (Inti < Sep)
