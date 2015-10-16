
%% -*- coding: utf-8 -*-
%% @author Adrian Insua y Aaron Montero
%% @version 1.
%% @doc Este modulo es una emulacion de la clase parser.java
-module(parser).
-export([parser/1]).

%% @doc Analiza el fichero y devuelve un array con las lineas
%% @spec parser(file())->array()
parser(File) ->
    case file:open(File, read) of
        {ok, Fd} ->
            readline(Fd,[]);
        {error, Cause} -> {error, Cause}
    end.

readline(Device, Accum) ->
    case io:get_line(Device, "") of
        eof -> file:close(Device), devolver(lists:reverse(Accum));
        Line -> readline(Device, [string:sub_string(Line,1,string:len(Line)-1)|Accum])
    end.

devolver([H|T]) ->
    {Val,_} = string:to_integer(H),
    ArrayAux = array:from_list(T),
    Dim = math:pow(2,Val),
    Return = subarrays(ArrayAux,0,Dim),
    {trunc(Dim),Return}.

subarrays(Array,Count,Dim) when (Count < Dim) ->
    Aux = array:from_list(array:get(Count,Array)),
    subarrays(array:set(Count,Aux,Array),Count + 1, Dim);
subarrays(Array,_,_) -> Array.
