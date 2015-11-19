-module(estacion).
-export([start/0]).
-export([stop/0]).

start() ->
	Pid = spawn(fun estacion/0),
	register(estacion,Pid).

stop() -> estacion ! stop.

estacion() ->
	estacion([X || X<-nodes(), X /= cliente@suampa]).
estacion(Lista) ->
	io:format("~w~n",[Lista]),
	receive
		{trabajar, N, From} ->
			I = N rem length(Lista),
			case N rem 2 of
				0 ->
					timer:sleep(trunc(timer:seconds(random:uniform()/1000))),
					From ! ok;
				1 ->
					{estacion,lists:nth(I+1,Lista)} ! {trabajar, N+1, self()},
					receive
						ok -> From ! ok
					end
			end,
			estacion(Lista);
		stop -> unregister(estacion)
	end.
