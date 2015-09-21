-module(manipulating).
-export([filter/2, reverse/1, concatenate/1, flatten/1]).

%%Filtrado (Se utiliza list comprehension) 
filter(Lista, N) ->
    [X || X <- Lista, X=<N].

%%Inversa
reverse(Lista) ->
    reverse(Lista, []).
%%funcion recursiva para la inversion
reverse([H|T], Acum) ->
    reverse(T, [H|Acum]);
reverse([], Acum) -> Acum.

%%Concatenacion
%%Se usa la funcion reverse ya que la recursion invierte la lista inicial
concatenate(Lista) ->
  concatenate(Lista, [], []).

%%Recursiva axuliar
%%si es lista hace la recursividad llamando tambien en el acumulador
%concatenate([H|T], Acum) when is_list(H) -> 
%    concatenate(T, concatenate(H, Acum));
%concatenate([H|T], Acum) -> concatenate(T, [H|Acum]);
%concatenate([], Acum) -> Acum.


%%Recursiva desde cola
concatenate([H|T],Cola, Acum) when is_list(H) ->    
    concatenate(H, [T|Cola], Acum);
concatenate([H|T], Cola, Acum) ->
    concatenate(T, Cola, [H|Acum]);
concatenate([], [H|T], Acum) ->
    concatenate(H, T, Acum);
concatenate([],[],Acum) -> reverse(Acum).



%%Función aplanamiento
flatten(List) ->
    flatten(List,[], []).
   
flatten([H|T],Cola, Acum) when is_list(H) -> 
    flatten(H, [T|Cola], Acum);
flatten([H|T],Cola,Acum) ->
    flatten(T, Cola, [H|Acum]);
flatten([],[H|T],Acum) -> flatten(H, T, Acum);
flatten([],[],Acum) -> reverse(Acum).
    

%%Recorre las listas hasta la ultima posicion, que estará vacia 
%%devolverá el acum vacio, entonces la funcion flatten matcherá con flatten(E, Acum).
%flatten([H|T], Acum) ->
%    flatten(H, flatten(T, Acum));
%flatten([], Acum) -> Acum;
%flatten(E, Acum) -> [E|Acum].

%%flatten con guardas
%flatten([],Acum) -> Acum;
%flatten([H|T], Acum) when is_list(H) -> flatten(T, flatten(H, Acum));
%flatten([H|T], Acum) -> flatten(T,[H|Acum]).
