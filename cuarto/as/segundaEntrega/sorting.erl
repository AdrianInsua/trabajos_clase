-module(sorting).
-export([quicksort/1, mergesort/1]).

quicksort([]) -> [];
quicksort([H|T]) ->
    quicksort([X|| X<-T, X < H]) ++ [H]++ quicksort([X|| X<-T, X >= H]).

mergesort([]) -> [];
mergesort([H]) -> [H];
mergesort(List) ->
    {List1,List2} =  lists:split(length(List) div 2, List),
    merge(mergesort(List1),mergesort(List2)).

merge([], List) ->
    List;
merge(List, []) ->
    List;
merge([H1|T1],[H2|T2]) ->
    if
        H1 =< H2 -> [H1| merge(T1, [H2|T2])];
        true -> [H2 | merge([H1|T1], T2)]
    end.
