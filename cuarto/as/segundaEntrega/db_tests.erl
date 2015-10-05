%% @author Adrian Insua
%% @version 1.0
%% @doc este modulo realiza los test para el modulo db
%% , los docs de las funciones no se generarán ya que no se hace una exportación de las mismas.
%% Se ha realizado un cambio en la funcion delete para que devolviera listas planas.

-module(db_tests).
-include_lib("eunit/include/eunit.hrl").

%%funcion mock para la creación de bases de datos con 3 elementos
crear_bd() ->
    Db = db:new(),
    Db1 = db:write(a,1,Db),
    Db2 = db:write(b,2,Db1),
    Db3 = db:write(c,3,Db2),
    Db3.

%% @doc prueba de la funcion new
new_test() ->
    ?assertEqual(db:new(), []).

%% @doc prueba de la funcion write
write_test() ->
    Db = crear_bd(),
    ?assertEqual([{c,3},{b,2},{a,1}], Db).

%% @doc prueba de la funcion delete
delete_test_() ->
    [fun delete1_test/0,
     fun delete2_test/0,
     fun delete3_test/0].

%%
%%Funciones de prueba de las varias posibilidades del delete
%%1 - ultimo elemento
%%2 - elemento en el medio
%%3 - primer elemento
%%

delete1_test() ->
    Db = crear_bd(),
    Dbdel = db:delete(a,Db),
    ?assertEqual([{c,3},{b,2}],Dbdel).

delete2_test() ->
    Db = crear_bd(),
    Dbdel = db:delete(b,Db),
    ?assertEqual([{c,3},{a,1}],Dbdel).

delete3_test() ->
    Db = crear_bd(),
    Dbdel = db:delete(c,Db),
    ?assertEqual([{b,2},{a,1}], Dbdel).

%% @doc prueba de la funcion read
read_test_() ->
    Db = crear_bd(),
   [?_assert(db:read(a,Db) =:= {ok, 1}),
    ?_assert(db:read(b,Db) =:= {ok, 2}),
    ?_assert(db:read(z,Db) =:= {error, instance})].

%% @doc prueba para la funcion match
match_test_() ->
    Db = crear_bd(),
    Db1 = db:write(d,1,Db),
    [?_assert(db:match(2,Db1) =:= [b]),
     ?_assert(db:match(1,Db1) =:= [a,d]),
     ?_assert(db:match(5,Db1) =:= [])].

%% @doc prueba de la funcion destroy
destroy_test() ->
    Db = crear_bd(),
    Dbdestroyed = db:destroy(Db),
    ?assert(Dbdestroyed =:= ok).


