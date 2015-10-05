%% @author Adrian Insua
%% @version 1.0
%% @doc este modulo realiza los test para el modulo boolean
%% los docs de las funciones no se generarán ya que no se hace una exportación de las mismas

-module(boolean_tests).
-include_lib("eunit/include/eunit.hrl").


%% Test de la funcion not
b_not_test() -> 
    ?assert(boolean:b_not(false)),
    ?assertNot(boolean:b_not(true)).

%% Test de la funcion and
b_and_test() -> 
     ?assert(boolean:b_and(true, true)),
     ?assertNot(boolean:b_and(true, false)),
     ?assertNot(boolean:b_and(false, false)),
     ?assertNot(boolean:b_and(false, true)).

%% Test de la funcion or
b_or_test() -> 
     ?assertNot(boolean:b_or(false, false)),
     ?assert(boolean:b_or(false, true)),
     ?assert(boolean:b_or(true, false)),
     ?assert(boolean:b_or(true, true)).
