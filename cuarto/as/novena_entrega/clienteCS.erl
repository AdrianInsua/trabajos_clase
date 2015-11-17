-module(clienteCS).
-export([start/0]).
-export([stop/0]).

start() ->
	Pid = spawn(fun cliente/0),
	register(clienteCS,Pid).

stop() ->
	clienteCS ! stop.

cliente() ->
	receive
		{enviar, N, From} ->
			{servidor, servidor@suampa} ! {balanceo,N,self()},
			receive
				ok -> From ! ok
			end,
			cliente();
		stop -> unregister(clienteCS)
	end.
