

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                      %%%
%%%    ESCALONAMENTOS    %%%
%%%                      %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%


calculaEmax(EMax,EMax,[]).
calculaEmax(PotMax,EMax,[H|T]) :-
		PotMaxNext is PotMax - H,
		calculaEmax(PotMaxNext,EMax,T).


separaTasks([],Tasks,Tasks,LS,LS,LE,LE).
separaTasks([SubTask|Next],SubTasks,Tasks,ListaStarts,LS,ListaEnds,LE) :-
		criaSubTask(SubTask,SubTasks,SubTasks1,ListaStarts,ListaStarts1,ListaEnds,ListaEnds1,_),
		separaTasks(Next,SubTasks1,Tasks,ListaStarts1,LS,ListaEnds1,LE).
		
criaSubTask([],Tasks,Tasks,LS,LS,LE,LE,_).
criaSubTask([Consumo|Next],ListaSubTasks,Tasks,ListaStarts,LS,ListaEnds,LE,S1) :-
		append(ListaSubTasks,[task(S1,1,E1,Consumo,0)],ListaSubTasks1),
		append(ListaStarts,[S1],ListaStarts1),
		append(ListaEnds,[E1],ListaEnds1),
		criaSubTask(Next,ListaSubTasks1,Tasks,ListaStarts1,LS,ListaEnds1,LE,E1).

getLength([ ], 0).
getLength([_|T],N) :- getLength(T,M), N  is  M+1.

doWhile(BaselinesFinal,BaselinesFinal,_,DeadlinesFinal,DeadlinesFinal,_,Amount1) :- Amount1 =<0,!.
doWhile(Baselines,BaselinesFinal,BaseLinesActuais,Deadlines,DeadlinesFinal,DeadLinesActuais,Amount) :-
			append(Baselines,[BaseLinesActuais],Baselines1),
			append(Deadlines,[DeadLinesActuais],Deadlines1),
			Amount1 is Amount - 1,
			doWhile(Baselines1,BaselinesFinal,BaseLinesActuais,Deadlines1,DeadlinesFinal,DeadLinesActuais,Amount1).

geraLines(_,ListaBaseLinesFinal,ListaBaseLinesFinal,_,ListaDeadlinesFinal,ListaDeadlinesFinal,[]).
geraLines([BaseLinesActuais|NextBaseline],BaseLines,ListaBaseLinesFinal,[DeadLinesActuais|NextDeadline],Deadlines,ListaDeadlinesFinal,[AmountSubtasks|NextAmount]):-
		doWhile(BaseLines,BaseLines1,BaseLinesActuais,Deadlines,Deadlines1,DeadLinesActuais,AmountSubtasks),
		geraLines(NextBaseline,BaseLines1,ListaBaseLinesFinal,NextDeadline,Deadlines1,ListaDeadlinesFinal,NextAmount).



restricaoTempo([],[],_).

%% Para o Baseline
restricaoTempo([Baseline|NextBase],[LS|NextS],0) :-
		LS #>=Baseline,
		restricaoTempo(NextBase,NextS,0).

%% Para o Endline	
restricaoTempo([Baseline|NextBase],[LS|NextS],1) :-
		LS #=<Baseline,
		restricaoTempo(NextBase,NextS,1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%ListaInicioTarefas= lista dos tempos iniciais das tarefas em que o primeiro elemento é a tarefa 1( nao implica que seja a primeira tarefa a ser feita)
%ListaFimTarefas=lista dos tempos finais das tarefas em que o primeiro elemento é a tarefa 1( nao implica que seja a primeira tarefa a ser feita)
%Tarefas= lista de task(...)
%PotenciaContratada 


% Sem considerar os não escalonaveis caso o valor passado em PotenciaContratadaRestante = PotenciaContratada se nao,
% PotenciaContratadaRestante= PotenciaContratada-Potencia consumida pelas tarefas nao escalonaveis,
% Assume-se que o pior caso é as tarefas nao escalonaveis terem uma duracao de 24h, assim sendo, a PotenciaRestante é um valor constante ao longo do dia

escalonamentoPorConsumoEnergetico(ListaInicioTarefas,ListaFimTarefas,Tarefas,PotenciaContratadaRestante):-

		domain(ListaInicioTarefas,0,23),
		domain(ListaFimTarefas,1,24),

		%%fazer as restricoes do tempo 
		restricaoTempo(ListaInicioTarefas,ListaInicioTarefasRestricoes,0),
		restricaoTempo(ListaFimTarefas,ListaFimTarefasRestricoes,1),

		LimiteEnergetico is 0..PotenciaContratadaRestante,

		cumulative(Tarefas,limit(LimiteEnergetico)),

		append(ListaInicioTarefasRestricoes,ListaFimTarefasRestricoes, Vars1),
		append(Vars1,[LimiteEnergetico], Vars),
		
		labeling([minimize(LimiteEnergetico)],Vars),


		% Mostrar Resultados
		write('Lista de Principios:'),write(ListaInicioTarefasRestricoes),write('\n'),
		write('Lista de Terminos:'),write(ListaFimTarefasRestricoes),write('\n'),
		write('Potencia Maxima Recomendada:'),write(LimiteEnergetico),write('\n'),
		write('Lista de Tarefas:'),write(Tarefas),write('\n').



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
calculaCustoTotal(_,[],CustoTotal,CustoTotal).

calculaCustoTotal(LCustos,[task(S,_,_,C,_)|NextTask],CustoActual,CustoTotal) :-
	element(S,LCustos,Custo),
	Mult #= Custo*C,
	CustoActual1 #= CustoActual + Custo*C,
	calculaCustoTotal(LCustos,NextTask,CustoActual1,CustoTotal).*/
		
		
calculaSomaCustos([],CustoMaximo,CustoMaximo).

calculaSomaCustos([C|NextC],CustoActual,CustoMaximo) :-
	CustoActual1 is CustoActual + C,
	calculaSomaCustos(NextC,CustoActual1,CustoMaximo).
		
calculaConsumoTotal([],ConsumoTotal,ConsumoTotal).

calculaConsumoTotal([task(_,_,_,C,_)|NextTask],ConsumoActual,ConsumoTotal) :-
	ConsumoActual1 is ConsumoActual + C,
	calculaConsumoTotal(NextTask,ConsumoActual1,ConsumoTotal).
		
minList([H|T], Min) :-
	minList(T, H, Min).
 
minList([], Min, Min).

minList([H|T], Min0, Min) :-
    Min1 is min(H, Min0),
    minList(T, Min1, Min).

% Para um Custo constante ao longo do tempo
% Sem considerar os não escalonaveis caso o valor passado em PotenciaContratadaRestante = PotenciaContratada se nao,
% PotenciaContratadaRestante= PotenciaContratada-Potencia consumida pelas tarefas nao escalonaveis,
% Assume-se que o pior caso é as tarefas nao escalonaveis terem uma duracao de 24h, assim sendo, a PotenciaRestante é um valor constante ao longo do dia

escalonamentoPeloCustoMinimo(ListaInicioTarefas,ListaFimTarefas,Tarefas,PotenciaContratadaRestante, Custo):-

		domain(ListaInicioTarefas,0,23),
		domain(ListaFimTarefas,1,24),

		%%fazer as restricoes do tempo 
		restricaoTempo(ListaInicioTarefas,ListaInicioTarefasRestricoes,0),
		restricaoTempo(ListaFimTarefas,ListaFimTarefasRestricoes,1),

		calculaSomaCustos(Custo,0,CustoMaximo),
		calculaConsumoTotal(Tarefas,0,ConsumoTotal),
		CustoTotal is CustoMaximo * ConsumoTotal,
		minList(ListaCustos,CustoMinimo),


		%calculaCustoTotal(LCustos,Tasks,0,ConsumoCusto),
		CustoTotal #= ConsumoCusto,


		LimiteEnergetico is 0..PotenciaContratadaRestante,

		cumulative(Tarefas,limit(LimiteEnergetico)),

		CustoLimite in CustoMinimo..CustoTotal,


		append(ListaInicioTarefasRestricoes,ListaFimTarefasRestricoes, Vars1),
		append(Vars1,[CustoLimite], Vars),
		
		labeling([minimize(CustoLimite)],Vars),

		% Mostrar Resultados
		write('Lista de Principios:'),write(ListaInicioTarefasRestricoes),write('\n'),
		write('Lista de Terminos:'),write(ListaFimTarefasRestricoes),write('\n'),
		write('Custo Otimo:'),write(CustoLimite),write('\n'),
		write('Lista de Tarefas:'),write(Tarefas),write('\n').


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 
escalonamentoPorConsumoEnergeticoComPotenciaContratadaRestanteVariavel(ListaInicioTarefas,ListaFimTarefas,Tarefas,ListaPotenciaContratadaRestante):-

		domain(ListaInicioTarefas,0,23),
		domain(ListaFimTarefas,1,24),

		%%fazer as restricoes do tempo 
		restricaoTempo(ListaInicioTarefas,ListaInicioTarefasRestricoes,0),
		restricaoTempo(ListaFimTarefas,ListaFimTarefasRestricoes,1),

		
		%assumir que o pior caso é o conjunto de tarefas que num determinado periodo de 1h consumiram o maior valor de potencia, isto é o menor valor da ListaPotenciaContratadaRestante
		minList(ListaPotenciaContratadaRestante,PotenciaContratadaRestante),
		
		LimiteEnergetico is 0..PotenciaContratadaRestante,

		cumulative(Tarefas,limit(LimiteEnergetico)),

		append(ListaInicioTarefasRestricoes,ListaFimTarefasRestricoes, Vars1),
		append(Vars1,[LimiteEnergetico], Vars),
		
		labeling([minimize(LimiteEnergetico)],Vars),

		% Mostrar Resultados
		write('Lista de Principios:'),write(ListaInicioTarefasRestricoes),write('\n'),
		write('Lista de Terminos:'),write(ListaFimTarefasRestricoes),write('\n'),
		write('Potencia Maxima Recomendada:'),write(LimiteEnergetico),write('\n'),
		write('Lista de Tarefas:'),write(Tarefas),write('\n').

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


escalonamentoPeloCustoMinimoComPotenciaContratadaRestanteVariavel(ListaInicioTarefas,ListaFimTarefas,Tarefas,ListaPotenciaContratadaRestante, Custo):-

		domain(ListaInicioTarefas,0,23),
		domain(ListaFimTarefas,1,24),

		%%fazer as restricoes do tempo 
		restricaoTempo(ListaInicioTarefas,ListaInicioTarefasRestricoes,0),
		restricaoTempo(ListaFimTarefas,ListaFimTarefasRestricoes,1),

		calculaSomaCustos(Custo,0,CustoMaximo),
		calculaConsumoTotal(Tarefas,0,ConsumoTotal),
		CustoTotal is CustoMaximo * ConsumoTotal,
		minList(ListaCustos,CustoMinimo),


		%calculaCustoTotal(LCustos,Tasks,0,ConsumoCusto),
		CustoTotal #= ConsumoCusto,

		minList(ListaPotenciaContratadaRestante,PotenciaContratadaRestante),

		LimiteEnergetico is 0..PotenciaContratadaRestante,

		cumulative(Tarefas,limit(LimiteEnergetico)),

		CustoLimite in CustoMinimo..CustoTotal,


		append(ListaInicioTarefasRestricoes,ListaFimTarefasRestricoes, Vars1),
		append(Vars1,[CustoLimite], Vars),
		
		labeling([minimize(CustoLimite)],Vars),

		% Mostrar Resultados
		write('Lista de Principios:'),write(ListaInicioTarefasRestricoes),write('\n'),
		write('Lista de Terminos:'),write(ListaFimTarefasRestricoes),write('\n'),
		write('Custo Otimo:'),write(CustoLimite),write('\n'),
		write('Lista de Tarefas:'),write(Tarefas),write('\n').

