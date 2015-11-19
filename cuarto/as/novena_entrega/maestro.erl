-module(maestro).
-export([start/0]).
-export([stop/0]).

start() ->
	Pid = spawn(fun maestro/0),
	register(maestro, Pid).

stop() ->
	maestro ! stop.

maestro() ->
	maestro(nodes(), 0).
maestro(List, Ocupados) ->
	receive
		{trabajo,From} when length(List)>0->
			{worker, lists:nth(1, List)} ! trabajo,
			From ! ok,
			maestro(lists:nthtail(1,List),Ocupados+1);
		{trabajo,From} ->
			receive
				{libre,Node} ->
					{worker,Node} ! trabajo,
					From ! ok,
					maestro(List, Ocupados)
			end;
		{libre,Nodo} ->
			maestro(lists:append([Nodo], List),Ocupados-1);
		{tiempo, From} when Ocupados > 0->
			From ! activo,
			maestro(List,Ocupados);
		{tiempo,From} ->
			From ! ok,
			maestro(List,Ocupados);
		stop -> unregister(maestro)
	end.
