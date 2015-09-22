-module(echo).
-export([start/0, stop/0, print/1]).
-export([init/0]).

%%Funcion para la creacion del proceso y su registro
start() ->
    Pid = spawn(?MODULE, init, []),
    register(server, Pid),
    ok.

%%Funcion que inicia el loop pasando una lista vacia
init() ->
    loop().


stop() ->
    server ! {stop, self()},
    receive
        {ok, server} -> ok
    end.

print(Term) ->
    server ! {print, Term, self()},
    receive
        {ok, server} -> ok
    end.

loop() ->
    receive
        {stop, From} ->
            From ! {ok, server};
        {print, Term, From} ->
            io:format("~s~n", [Term]),
            From ! {ok, server},
            loop()
    end.


