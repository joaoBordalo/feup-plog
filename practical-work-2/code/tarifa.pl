%%%%
%% defenição de tarifas
%%%%

%preco_tarifa(+IdTarifa,idPeriodo,+NomePeríodo,+Preco)

preco_tarifa(1,1,'Hora de Ponta',0.2066). % Euros/kWh 
preco_tarifa(1,2,'Hora de Cheia', 0.1642).
preco_tarifa(1,3,'Hora de Vazia', 0.0955).



%tarifa_horario(+Inicio,+Fim,+IdTarifa,+idPeriodo)

tarifa_horario(0,7,1,3).
tarifa_horario(7,9.5,1,2).
tarifa_horario(9.5,12,1,1).
tarifa_horario(12,18.5,1,2).
tarifa_horario(18.5,21,1,1).
tarifa_horario(21,24,1,2).

timelineDivison([0,7,9.5,12,18.5,21,24]).

%preco_timeline(-TimeLineCost,+CurrentTime,+Time,It)  no início CurrentTime = 0 e Time = 24, It vai percorrer a lista timelineDivison e tem de começar por 1

preco_timeline(TimeLineCost,Time,Time,TimelineDivison).
preco_timeline(TimeLineCost,CurrentTime,Time,It,TimelineDivison):-
												get2ConsecutiveElements(It,MinTime,MaxTime,TimelineDivison),
												between(MinTime,MaxTime,CurrentTime),
												append(TimeLineCost,[tarifa_horario(MinTime,MaxTime,_,_)],NewTimeLineCost),
												NewCurrentTime is CurrentTime + 0.5,
												preco_timeline(NewTimeLineCost,NewCurrentTime,Time,It,TimelineDivison).
preco_timeline(TimeLineCost,CurrentTime,Time,It,TimelineDivison):- 	NewIt is It+1,
																	preco_timeline(TimeLineCost,CurrentTime,Time,NewIt,TimelineDivison).




get2ConsecutiveElements(It,MinTime,MaxTime,TimelineDivison):- nth1(It,TimelineDivison, MinTime),
												NewIt is It+1,
												nth1(It,TimelineDivison, MaxTime).

between(MinTime,MaxTime,CurrentTime):- CurrentTime >= MinTime,
										CurrentTime =< MaxTime.



nth1(1, [Head|_], Head) :- !.

nth1(N, [_|Tail], Elem) :-
    nonvar(N),
    M is N-1,          
    nth1(M, Tail, Elem).

nth1(N,[_|T],Item) :-       
    var(N),        
    nth1(M,T,Item),
    N is M + 1.			