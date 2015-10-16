-module(parser).
-export([parser/1]).

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
    {trunc(math:pow(2,Val)),T}.
