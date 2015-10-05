%% @author Adrian Insua
%% @version 1.0
%% @doc este modulo realiza los test para el modulo db
%% , los docs de las funciones no se generarán ya que no se hace una exportación de las mismas.
%% Se ha realizado un cambio en la funcion delete para que devolviera listas planas.
%% Se ha incluido la recepcion del error de instancia no encontrada en la funcion delete, ya que se habia pasado por alto
%% Se ha cambiado la funcion destroy para que funcione como stop tambien

-module(db_tests).
-include_lib("eunit/include/eunit.hrl").

%%funcion mock para la creación de bases de datos con 3 elementos
crear_bd() ->
    db:new(),
    db:write(a,1),
    db:write(b,2),
    db:write(c,3).

%% @doc prueba de la funcion new
new_test() ->
    ?assertEqual(db:new(), ok).

%% @doc prueba de la funcion write
write_test() ->
    ?assert(db:write(a,1) =:= ok).

%% @doc prueba de la funcion delete
delete_test() ->
    db:write(a,1), 
    Res = db:delete(a),
    Fallo = db:delete(z),
    ?assert(Res =:= ok),
    ?assert(Fallo =:= {not_found, instance}).

%% @doc prueba de la funcion read
read_test_() ->
    db:destroy(),
    crear_bd(),
   [?_assert(db:read(a) =:= {ok, 1}),
    ?_assert(db:read(b) =:= {ok, 2}),
    ?_assert(db:read(z) =:= {error, instance})].

%% @doc prueba para la funcion match
match_test_() ->
    db:write(d,1),
    [?_assert(db:match(2) =:= [b]),
     ?_assert(db:match(1) =:= [a,d]),
     ?_assert(db:match(5) =:= [])].

%% @doc prueba de la funcion destroy
destroy_test() ->
    ?assert(db:destroy() =:= ok).


