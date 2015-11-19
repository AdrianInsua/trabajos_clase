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
		trabajo ->
			timer:sleep(trunc(timer:seconds(random:uniform()/1000))),
			{maestro, cliente@suampa} ! {libre,node()},
			worker();
		stop -> unregister(worker)
	end.
