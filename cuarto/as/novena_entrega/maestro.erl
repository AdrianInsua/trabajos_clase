-module(maestro).
-export([start/0]).
-export([stop/0]).

start() ->
	Pid = spawn(fun maestro/0),
	register(maestro, Pid).

stop() ->
	maestro ! stop.

maestro() ->
	maestro(nodes(), 0, 0).
maestro(List, Time, Ocupados) ->
	receive
		trabajo when length(List)>0->
			{H,M,S} = time(),
			{worker, lists:nth(1, List)} ! {trabajo, timer:hms(H,M,S),self()},
			maestro(lists:nthtail(1,List),Time,Ocupados+1);
		trabajo ->
			{worker, lists:nth(1, List)} ! {trabajo,self()},
			receive
				{libre,Time,Nodo} ->
					{H,M,S} = time(),
					Tf = timer:hms(H,M,S) - Time,
					{worker,Nodo} ! {trabajo,timer:hms(H,M,S),self()}
			end,
			maestro(List, Time+Tf, Ocupados);
		{libre,Time,Nodo} ->
			{H,M,S} = time(),
			Tf = timer:hms(H,M,S) - Time,
			maestro(lists:append(Nodo, List), Time+Tf, Ocupados-1);
		{tiempo, From} when Ocupados > 0->
			From ! activo,
			maestro(List,Time,Ocupados);
		{timepo,From} ->
			From ! Time,
			maestro(List,Time,Ocupados);
		stop -> unregister(maestro)
	end.
