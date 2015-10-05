-module(effects).
-export([print/1, even_print/1]).
-import(create, [create/1]).

%%Impresion normal
print(N) ->
    io:fwrite("~w~n", [create:create(N)]).


%%Funcion para la impresion de enteros pares
even_print(N) ->
 io:fwrite("~w~n", [[X || X <- create:create(N), X rem 2 == 0]]).
%% se puede crear una lista con guardas e imprimirla
 %%   io:fwrite("~w~n", [even_create(N)]).  

%even_create(N) ->
%    even_create(N, []).
%
%even_create(0, List) -> List;
%even_create(N, List) when N rem 2 == 0, N > -2->
%    even_create(N-1, [N|List]);
%even_create(N, List) -> even_create(N-1, List).
