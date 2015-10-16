%% -*- coding: utf-8 -*-
%% @author Adrian Insua
%% @version 1.
%% @doc This module creates a ring which is useful to try distributed coding and error handling in Erlang.<br/>
%% A 'head' process is created and it handles the creation and comunication with the ring's processes.
%%
%% An update calls control the hot code swapping before we call the actual command.
%%
%% This module monitorizes 'EXIT' signals travelling through ring. If we find one of these signals we try to repair the ring changing the deprecated pointers.
-module(ring).
-export([start/1, start/2, msg/2, msg/3, stop/0, stop/1, head_proc/1, link_proc/1]).
-export([head/0]).
-export([get_process/1]).

%% @doc with args: NumProc, Node. Sends a create signal to Node, so the node will create NumProc processes.
%% @spec start(integer(),node()) -> any()
start(0,_) -> {error, invalid_argument};
start(NumProc,Node) ->
    Pid = spawn(Node, ?MODULE, head, []),
    io:format("~w~n",[Pid]),
    Pid ! {spawn, NumProc},
    ok.

%% @doc with arg: NumProc. This function creates NumProc processes connected between them in a ring topology.
%% @spec start(integer()) -> atom()
start(NumProc) when NumProc > 0 ->
    Pid = spawn(?MODULE, head, []),
    Pid ! {spawn, NumProc},
    ok;
start(0) -> 
    {error, invalid_argument}.

%% @doc with args: MsgNum, Message, Node. Send a message signal to the specificated Node and it sends through his ring the Message for MsgNum times.
%% @spec msg(integer(),any(),node()) -> iodata()
msg(MsgNum, Message, Node) ->
    {head, Node} ! {msg, Message, MsgNum}.

%% @doc with args: MsgNum, Message. Sends to the ring Message for MsgNum times.
%% @spec msg(integer(),any()) -> iodata()
msg(MsgNum, Message) ->
    head ! {msg, Message, MsgNum}.

%% @doc with arg: Node. Sends to the specified Node the stop signal.
%% @spec stop(node()) -> any()
stop(Node) ->
    {head, Node} ! stop.   

%% @doc without args. Sends the stop signal to the ring.
stop() ->
    head ! stop.

%% @doc with arg: NProcess. Auxiliar function which returns the NProcess-th Pid of the ring.
%% @spec get_process(integer()) -> [pid()|iodata()]
get_process(NProcess) ->
    head ! {getProc, NProcess, self()},
    receive
        {res, error} -> io:format("We can't find any process~n"), error;
        {res, Pid} -> Pid
    end.

head() ->
    register(head, self()),
    process_flag(trap_exit, true), %%monitorize 'EXIT' signals coming from any ring's process
    head_proc([]).

%% @hidden it is an internal function
head_proc(Anillo) ->
    process_flag(trap_exit, true),
    receive
        {spawn, N} ->
            Prim = spawn_link(?MODULE, link_proc, [nil]),
            register(anillo, Prim),
            spawn_proc(N-1, Prim, self()),
            ?MODULE:head_proc([Prim|Anillo]);
        {reg, Proc} ->
            ?MODULE:head_proc([Proc|Anillo]);
        {msg, Mensaje, Num} ->
            send_msg(Mensaje, Num),
            ?MODULE:head_proc(Anillo);
        {getProc, N, From}->
            try lists:nth(N, Anillo) of
                _ -> Lista = lists:reverse(Anillo),
                     From ! {res, lists:nth(N,Lista)}
            catch
                _:_ -> From ! {res, error}
            end,
            ?MODULE:head_proc(Anillo);
        {'EXIT', Pid, Reason} ->
            io:format("Process ~w closed by error: ~w~nWe are fixing ring....~n", [Pid,Reason]),
            AnilloNuevo = fix(lists:reverse(Anillo), Pid, nil, []),
            if
                length(AnilloNuevo) =:= 0 -> unregister(head), exit(self(),ok);
                true -> ?MODULE:head_proc(AnilloNuevo)
            end;
        stop ->
            stopAux(),
            unregister(head),
            exit(self(), ok)
    end.

%% @hidden it is an internal function
link_proc(Next) ->
    receive
        {reg, Pid} ->
            ?MODULE:link_proc(Pid);
        {msg, Msg} ->
            io:fwrite("~w mensaje a: ~w Siguiente: ~w ~n", [self(),Msg, Next]),
            if
                (Next =/= anillo) -> Next ! {msg, Msg},
                    ?MODULE:link_proc(Next);
                true -> ?MODULE:link_proc(Next)
            end;
        stop ->
            unlink(self()),
            if
                (Next =/= anillo) ->
                    Next ! stop,
                    exit(self(), ok);
                true -> 
                    exit(self(),ok)
            end
    end.

spawn_proc(0, Prev,_) -> 
    Prev ! {reg, anillo};
spawn_proc(N, Prev, From) -> 
    Pid = spawn_link(?MODULE, link_proc, [nil]),
    Prev ! {reg, Pid},
    From ! {reg, Pid},
    spawn_proc(N-1, Pid, From).

send_msg(_, 0) -> ok;
send_msg(Msg, Num) ->
    anillo ! {msg, Msg},
    send_msg(Msg, Num-1).

fix([], _, _, _) -> [];
fix([Pid,H|[]], Pid, nil, _) -> %%this option is for the cases with only 2 ring elements
    register(anillo,H),
    [H];
fix([Pid,H|T], Pid, Ant, Acum) ->
    Ant ! {reg, H},
    Aux = lists:reverse([H|T]),
    NuevaLista = lists:append(Aux, Acum),
    NuevaLista; %% returns the new list, with all elements but the deleted one.
fix([H|T], Pid, _, Acum) ->
    fix(T, Pid, H, [H|Acum]).

stopAux() ->
    anillo ! stop,
    unregister(anillo).

