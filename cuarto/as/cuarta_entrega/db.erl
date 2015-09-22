-module(db).
-export([new/0, write/2, delete/1, read/1, match/1, destroy/0,stop/0]).
-export([init/0]).


%%Funciones de interfaz
new() ->
    Pid = spawn(?MODULE, init, []),
    register(server, Pid),
    ok.

init() ->
    loop([]).

write(K,E) ->
    server ! {write, {K,E}, self()},
    receive
        {ok, server} -> ok
    end.

delete(K) ->
    server ! {delete, K, self()},
    receive
        {Res, server} -> Res
    end.

read(K) ->
    server ! {read, K, self()},
    receive
        {Res, server} -> Res;
        {error, _} -> {error, instanceNotFound}
    end.

match(E) ->
    server ! {match, E, self()},
    receive
        {Res, server} -> Res
    end.

destroy() ->
    server ! {destroy, self()},
    receive
        {ok, server} -> ok
    end.

stop() ->
    server ! {stop,self()},
    receive
        {ok, server} -> ok
    end.
        

%%Funcion de loop que conserva la DB
loop(Db) ->
    receive
        {write, Nuevo, From} ->
            From ! {ok, server},
            loop([Nuevo|Db]);
        {delete, K, From} ->
            NewDb = delete(K, Db, []),
            if
                length(NewDb) == length(Db) -> From ! {not_found, instance};
                length(NewDb) /= length(Db) -> From ! {ok, server}
            end,
            loop(NewDb);
        {read, K, From} -> 
            From !{read(K,Db),server},
            loop(Db);
        {match, E, From} ->
            From ! {match(E,Db,[]), server},
            loop(Db);
        {stop, From} -> From ! {ok, server};
        {destroy, From} ->
            From ! {ok, server},
            loop([])
    end.


%%Funciones internas para la realización de tareas
delete(_,[],Acum) -> Acum;
delete(K,[{K1,V}|T], Acum) ->
    if
        K1 == K -> [Acum|T];
        true -> delete(K,T,[{K1,V}|Acum])
    end.

read(K,[H|T]) ->
    case H of
        {K, Element} ->
            {ok, Element};
        _ ->
            read(K, T)
    end;
read(_,[]) -> {error, instance}.

match(E,[H|T], Acum) ->
    case H of
        {K, E} -> match(E,T,[K|Acum]);
        _ -> match(E, T, Acum)
    end;
match(_,[],Acum) -> Acum.

