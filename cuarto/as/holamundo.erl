-module(holamundo).
-export([hola_mundo/1]).

hola_mundo(Nombre) ->
    %% io.format es la funcion estandard para la salida de texto por pantalla
    io:format("Hola mundo ~s ~n", [Nombre] ).

