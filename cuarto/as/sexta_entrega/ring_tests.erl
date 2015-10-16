%% -*- coding: utf-8 -*-
%% @author Adrian Insua Yañez
%% @copyright 2015
%% @version 1.0
%% @doc Test module for ring TGR

-module(ring_tests).
-include_lib("eunit/include/eunit.hrl").

%% @doc execute in order the tests, initializing first, and stopping at the end
ring_test_() ->
    {inorder,
        {setup,
         fun start_ring/0,
         fun stop_ring/1,[
            ?_test(start()),
            ?_test(start_fallo()),
            ?_test(get_proc()),
            ?_test(msg()),
            %%?_test(code_swap()), %%Comentado ya que hace que falle el cover
            ?_test(msg_kill()),
            ?_test(kill_first())
         ]}
}.

%% @doc starting function
start_ring() ->
    ring:start(3),
    timer:sleep(50).

%% @doc stopping function
stop_ring(_) ->
    ring:stop().

%% @doc normal start checking
start() ->
 Head = whereis(anillo),
 P1 = ring:get_process(1),
 P2 = ring:get_process(2),   
 P3 = ring:get_process(3),   
 [?assertNotEqual(Head, undefined),
 ?assertNotEqual(P1, error),
 ?assertNotEqual(P2, error),
 ?assertNotEqual(P3, errpr)].

%% @doc wrong start checking
start_fallo() ->
    Error = ring:start(0),
    ?assertEqual(Error, {error, invalid_argument}).
    
%% @doc msg sending test, each process has to send at least 2 signal to the io to print
msg() ->
    Tracer = spawn(fun tracer/0),
    P1 = ring:get_process(2),
    erlang:trace(P1, true, [send,{tracer,Tracer}]),
    ring:msg(2,hola),
    timer:sleep(50),
    erlang:trace(all,false,[all]),
    Tracer ! {collect, self()},
        receive {Traces, Tracer} -> Traces end,
        PrintTraces = [ print_trace || {trace,Who,send,{io_request,_,_,_},_} <- Traces, Who == P1],
        ?assertEqual(2, length(PrintTraces)).

%% @doc msg test after killing a process. The process before the killed one will be pointing the next process skipping one.
msg_kill() ->
    Tracer = spawn(fun tracer/0),
    P1 = ring:get_process(1),
    P2 = ring:get_process(2),
    P3 = ring:get_process(3),
    io:format("~w, ~w~n",[P1,P2]),
    exit(P2, ok),
    timer:sleep(50),
    erlang:trace(P1, true, [send, {tracer, Tracer}]),
    ring:msg(2,hola),
    timer:sleep(50),
    erlang:trace(all, false, [all]),   
    Tracer ! {collect, self()},
        receive {Traces, Tracer} -> Traces end,
        io:format("~w~n",[Traces]),
        PrintTraces = [ print_trace || {trace,Who,send,{io_request,_,_,_},_} <- Traces, Who == P1],
        PrintTracesSend = [ print_trace || {trace,Who,send,{msg,_},To} <- Traces, (Who == P1) and (To == P3)],
        ?assertEqual(2, length(PrintTraces)),
        ?assertEqual(2, length(PrintTracesSend)).

%% @doc test about killing the first element of the ring, so we have to change the ring's head variable
kill_first() ->
    P1 = ring:get_process(1),
    exit(whereis(anillo), exit),
    timer:sleep(50),
    P2 = ring:get_process(1),
    ?assertNotEqual(P1,P2).

%%code_swap() ->
%%    Tracer = spawn(fun tracer/0),
%%    P1 = ring:get_process(1),
%%    code_change(),
%%    erlang:trace(P1, true, [send, {tracer, Tracer}]),
%%    ring:msg(2,hola),
%%    timer:sleep(50),
%%    erlang:trace(all, false, [all]),
%%    code_change(),
%%    Tracer ! {collect, self()},
%%        receive {Traces, Tracer} -> Traces end,
%%        io:format("~w~n",[Traces]),
%%        PrintTracesSendAnt = [ print_trace || {trace,Who,send,{msg,_},_} <- Traces, (Who == P1)],
%%        PrintTracesSend = [ print_trace || {trace,Who,send,{_,msg},_} <- Traces, (Who == P1)],
%%        ?assertEqual(1, length(PrintTracesSendAnt)),
%%        ?assertEqual(1, length(PrintTracesSend)).
%%  
%%code_change() ->
%%    os:cmd("./cambio.sh"),
%%    code:purge(ring),
%%    compile:file(ring),
%%    code:load_file(ring).
    
%% @doc test about the auxiliar function, get_process, one ok one wrong.
get_proc() ->
    P1 = ring:get_process(1),
    P4 = ring:get_process(4),
    ?assertNotEqual(P1, error),
    ?assertEqual(P4, error).

stop_test() ->
    ring:start(3),
    timer:sleep(50),
    ring:stop(),
    timer:sleep(50),
    ?assertEqual(whereis(head), undefined).

%% internal tracing functions.
tracer() ->
    tracer([]).

tracer(TL) ->
    receive
        {collect, From} ->
            From ! {lists:reverse(TL), self()};
        Other ->
            tracer([Other|TL])
    end.
