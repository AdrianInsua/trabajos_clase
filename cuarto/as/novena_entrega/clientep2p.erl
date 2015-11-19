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
			I = N rem length(nodes()),
			{estacion, lists:nth(I+1, nodes())} ! {trabajar, N, self()},
			receive
				ok -> From ! ok
			end,
			cliente();	
		stop -> unregister(cp2p)
	end.
