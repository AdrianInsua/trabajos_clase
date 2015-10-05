-module(traces).
-export([prueba/0]).

prueba() ->
    Tracer = spawn(fun tracer/0),
    erlang:trace(whereis(server), true, [send, {tracer,Tracer}]),
    erlang:trace(all,false,[all]),
    timer:sleep(500),
    Tracer ! {collect, self()},
    receive {Traces, Tracer} -> Traces end,
    Traces.

tracer() ->
    tracer([]).

tracer(TL) ->
    receive
        {collect, From} ->
            From ! {lists:reverse(TL), self()};
        Other ->
            tracer([Other|TL])
    end.
