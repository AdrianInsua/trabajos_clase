-module(cliente).
-export([probar_cs/0, probar_ms/0, probar_p2p/0]).

probar_cs() ->
	{Time,_} = timer:tc(fun probarCS/0),
	Time/500.

probarCS() ->
	probarCS(500).
probarCS(0) -> ok;
probarCS(N) ->
	clienteCS ! {enviar,N,self()},
	receive
		ok -> probarCS(N-1)
	end.
		
probar_ms() ->
	probar_ms(500).

probar_ms(0) ->
	maestro ! {tiempo, self()},
	receive
		activo -> probar_ms(0);
		Time -> Time/500
	end;
probar_ms(N) ->
	maestro ! trabajo,
	probar_ms(N-1).

probar_p2p() ->
	{Time,_} = timer:tc(fun probarP2P/0),
	Time/500.

probarP2P() ->
	probarP2P(500).

probarP2P(0) -> ok;
probarP2P(N) -> 
	cp2p ! {trabajo, N, self()},
	receive
		ok -> probarP2P(N-1)
	end.
