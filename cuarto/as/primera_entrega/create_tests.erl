
%% @author Adrian Insua
%% @version 1.0
%% @doc este modulo realiza los test para el modulo create
%% los docs de las funciones no se generarán ya que no se hace una exportación de las mismas

-module(create_tests).
-include_lib("eunit/include/eunit.hrl").


create_test() ->
    ?assertEqual(create:create(0), []),
    ?assertEqual(create:create(1), [1]),
    ?assertEqual(create:create(2), [1,2]),
    ?assertEqual(create:create(3), [1,2,3]),
    ?assertEqual(create:create(11), [1,2,3,4,5,6,7,8,9,10,11]).

reverse_create_test() ->
    ?assertEqual(create:reverse_create(0), []),
    ?assertEqual(create:reverse_create(1), [1]),
    ?assertEqual(create:reverse_create(2), [2,1]),
    ?assertEqual(create:reverse_create(3), [3,2,1]),
    ?assertEqual(create:reverse_create(11), [11,10,9,8,7,6,5,4,3,2,1]).
