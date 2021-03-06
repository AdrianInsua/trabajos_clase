-module(db).
-export([new/0, write/3, delete/2, read/2, match/2, destroy/1]).

new() ->
    [].

write(K, E, L) ->
    [{K,E}|L].

delete(K, L) ->
    delete(K,L,[]).

delete(_,[],[H|T]) -> 
    reverse(T,[H|[]]);
delete(K,[{K1,V}|T], Acum) ->
    if
        K1 == K -> delete([],T,Acum);
        true -> delete(K,T,[{K1,V}|Acum])
    end.

reverse([H|T],Acc) ->
    reverse(T, [H|Acc]);
reverse([],Acc) -> Acc.

read(K,[H|T]) ->
    case H of
        {K, Element} ->
            {ok, Element};
        _ ->
            read(K, T)
    end;
read(_,[]) -> {error, instance}.

match(E,L) ->
    match(E,L,[]).
match(E,[H|T], Acum) ->
    case H of
        {K, E} -> match(E,T,[K|Acum]);
        _ -> match(E, T, Acum)
    end;
match(_,[],Acum) -> Acum.

destroy(_) -> ok.
