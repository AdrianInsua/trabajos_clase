-module(worker).
-export([start/0]).
-export([stop/0]).

start() ->
	Pid = spawn(fun worker/0),
	register(worker, Pid).

stop() ->
	worker ! stop.

worker() ->
	receive
		{trabajo, Time, From} ->
			timer:sleep(trunc(timer:seconds(random:uniform()/1000))),
			From ! {libre,Time, node()},
			worker();
		stop -> unregister(worker)
	end.
