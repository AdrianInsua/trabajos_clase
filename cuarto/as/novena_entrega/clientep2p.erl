-module(clientep2p).
-export([start/0]).
-export([stop/0]).

start() ->
	Pid = spawn(fun cliente/0),
	register(cp2p,Pid).

stop() ->
	cp2p ! stop.

cliente() ->
	receive
		{trabajo, N, From} ->
			{estacion, lists:nth((N rem 4)+1, nodes())} ! {trabajar, self()},
			receive
				ok -> From ! ok
			end,
			cliente();	
		stop -> unregister(cp2p)
	end.
