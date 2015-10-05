%% @author Adrian Insua
%% @version 1.0
%% @doc este modulo realiza los test para el modulo echo
%% , los docs de las funciones no se generarán ya que no se hace una exportación de las mismas.

-module(echo_tests).
-include_lib("eunit/include/eunit.hrl").


%% @doc funcion de prueba de creacion de servicio
start_test() ->
    echo:start(),
    ?assert(whereis(server) =/= undefined),
    echo:stop().

%% @doc funcion de prueba del stop del servicio
stop_test() ->
    echo:start(),
    echo:stop(),
    ?assert(whereis(server) =:= undefined).


%% @doc funcion de prueba de la funcion print
print_test() ->
    echo:start(),
    Tracer = spawn(fun tracer/0),
    S = whereis(server),
    erlang:trace(S, true, [send,{tracer,Tracer}]),
    echo:print(a),
    erlang:trace(all,false,[all]),
    timer:sleep(500),
    Tracer ! {collect, self()},
        receive {Traces, Tracer} -> Traces end,
    ?assert(Traces =/= []).


tracer() ->
    tracer([]).

tracer(TL) ->
    receive
        {collect, From} ->
            From ! {lists:reverse(TL), self()};
        Other ->
            tracer([Other|TL])
    end.
