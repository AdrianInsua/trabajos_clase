-module(servidorCS).
-export([start/0]).
-export([stop/0]).

start() ->
	Pid = spawn(fun server/0),
	register(servidor, Pid).

stop() ->
	servidor ! stop.
server() ->
	server([X || X<-nodes(), X /= cliente@suampa]).
server(Lista) ->
	receive
		{balanceo,N,From} -> 
			lists:nth((N rem 3)+1,Lista) ! {trabajo, self()},
			receive
				ok -> From ! ok
			end,
			server(Lista);
		{trabajo,From} ->
			timer:sleep(trunc(timer:seconds(random:uniform()/1000))),
			From ! ok,
			server(Lista);
		stop -> unregister(servidor)
	end.
