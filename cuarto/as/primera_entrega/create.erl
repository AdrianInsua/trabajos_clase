-module(create).
-export([create/1, reverse_create/1]).

%%Creación normal
create(Valor) ->
    create(Valor, []).

%%Funcion tail_recursive
create(Valor, List) when Valor > 0 ->
    create(Valor-1, [Valor|List]);
create(0, List) -> List.

%%Creacion invertida
reverse_create(Valor) ->
    reverse_create(Valor, 1, []).

%funcion recursiva normal, acumula operaciones
%reverse_create(Valor) when Valor > 0 ->
%    [Valor|reverse_create(Valor-1)];
%reverse_create(0) -> [].

%%Funcion tail_recusive
reverse_create(Valor, N, List) when N =< Valor ->
    reverse_create(Valor, N+1, [N|List]);
reverse_create(_, _, List) -> List.
