-module(clienteServidor).
-export([empezar/0]).
-export([stop/0]).

empezar() ->
    Servidor = spawn(fun servidor/0),
    register(servidor, Servidor),
    {Time,_} = timer:tc(fun enviar/0),
    Time /500.

enviar() ->
    enviar(500).
enviar(0) -> ok;
enviar(N) ->
    if
        N rem 2  == 0 ->
            servidor ! {servicio, 1 ,self()},
            receive
                ok -> ok
            end;
        N rem 3 == 0 ->
            servidor ! {servicio, 2 ,self()},
            receive
                ok -> ok
            end;
        N rem 5 == 0 ->
            servidor ! {servicio, 3 ,self()},
            receive
                ok -> ok
            end;
        true ->
            servidor ! {servicio, 4 ,self()},
            receive
                ok -> ok
            end
    end,
    enviar(N-1).

stop() ->
    servidor ! stop.

servidor() ->
    receive
        {servicio, 1, From} ->
            servicio1(),
            From ! ok,
            servidor();
        {servicio, 2, From} ->
            servicio2(),
            From ! ok,
            servidor();
        {servicio, 3, From} ->
            servicio3(),
            From ! ok,
            servidor();
        {servicio, 4, From} ->
            servicio4(),
            From ! ok,
            servidor();
        stop ->
            unregister(servidor)
    end.

servicio1() ->
    timer:sleep(trunc(timer:seconds(random:uniform()/100))).

servicio2() ->
    timer:sleep(trunc(timer:seconds(random:uniform()/100))).

servicio3() ->
    timer:sleep(trunc(timer:seconds(random:uniform()/100))).

servicio4() ->
    timer:sleep(trunc(timer:seconds(random:uniform()/100))).
