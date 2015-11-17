-module(estacion).
-export([start/0]).
-export([stop/0]).

start() ->
	Pid = spawn(fun estacion/0),
	register(estacion,Pid).

stop() -> estacion ! stop.

estacion() ->
	receive
		{trabajar, From} ->
			timer:sleep(trunc(timer:seconds(random:uniform()/1000))),
			From ! ok,
			estacion();
		stop -> unregister(estacion)
	end.
