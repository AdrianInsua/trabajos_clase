%% @author Adrian Insua
%% @version 1.0
%% @doc este modulo realiza los test para el modulo sorting
%% , los docs de las funciones no se generarán ya que no se hace una exportación de las mismas

-module(sorting_tests).
-include_lib("eunit/include/eunit.hrl").

quicksort_test() ->
    ?assertEqual(sorting:quicksort([]), []),
    ?assertEqual(sorting:quicksort([1]), [1]),
    ?assertEqual(sorting:quicksort([1,3,2]), [1,2,3]).


%% @TODO test mergesort
mergesort_test() ->
    ?assertEqual(sorting:mergesort([]), []),
    ?assertEqual(sorting:mergesort([1]), [1]),
    ?assertEqual(sorting:mergesort([1,3,2]), [1,2,3]).
