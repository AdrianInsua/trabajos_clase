%% @author Adrian Insua
%% @version 1.0
%% @doc este modulo realiza los test para el modulo manipulating
%% los docs de las funciones no se generarán ya que no se hace una exportación de las mismas

-module(manipulating_tests).
-include_lib("eunit/include/eunit.hrl").

%% @doc filter_test realiza las pruebas para la función de filtrado

filter_test() ->    
    ?assertEqual(manipulating:filter([],1), []),
    ?assertEqual(manipulating:filter([1,2,3,4],1), [1]),
    ?assertEqual(manipulating:filter([1,2,3,4],3), [1,2,3]).

%% @doc reverse_test realiza las pruebas para la funcion de inversion

reverse_test() ->
    ?assertEqual(manipulating:reverse([]), []),
    ?assertEqual(manipulating:reverse([1]), [1]),
    ?assertEqual(manipulating:reverse([1,2]), [2,1]).

%% @doc concatenate_test realiza las pruebas para la funcion de concatenacion

concatenate_test() ->
    ?assertEqual(manipulating:concatenate([]),[]),
    ?assertEqual(manipulating:concatenate([[1,2],[3,4],[5,[6],7]]),[1,2,3,4,5,[6],7]).

%% @doc flatten_test realiza las pruebas para la funcion de aplanado
%% @see doc/1

flatten_test() ->
    ?assertEqual(manipulating:flatten([]),[]),
    ?assertEqual(manipulating:flatten([[1,2,3],[5,6]]),[1,2,3,5,6]),
    ?assertEqual(manipulating:flatten([[1,2,[3]],[4,5],[6,7,[8,[9]]]]),[1,2,3,4,5,6,7,8,9]).
    
