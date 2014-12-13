% interface gráfica

:- use_module(library(clpfd)).



/*
main_menu():-  	write('****************************'),
				nl,
				write('**                        **'),
				nl,
				write('**  Welcome to SmartGrid  **'),
				nl,
				write('**                        **'),
				nl,
				write('****************************'),
				nl,nl,
				write('Choose an option:'),
				nl,
				write('1-Manage Tasks and Devices'),
				nl,
				write('2-'),
				nl,
				write('').







taskNotSchedule(+Baseline,+Duracao,+Deadline,+Consumo,+IdMaquina,+IdTarefa).


task(+Baseline,+Duracao,+Deadline,+Consumo,+IdMaquina,+IdTarefa).



machine(1,X1).
machine(2,X2).
machine(3,X3).
machine(4,X4).
machine(5,X5).
machine(6,X6).



aparelho(1,'Maquina de Lavar Roupa',25,1).
aparelho(2,'Maquina de Lavar Louça',67,1).
aparelho(3,'Televisao', 3,0).
aparelho(4,'Forno', 17,1).
aparelho(5,'Aquecedor',7,1).
aparelho(6,'Frigorífico' 10,0).


createMachines(Machines,MaxMachine,MaxMachine).
createMachines(Machines, CurrentMachine,MaxMachine):-	append(Machines,[machine(CurrentMachine,X1)],NewMachines),
														NewCurrentMachine is CurrentMachine+1,
														createMachines(NewMachines,NewCurrentMachine,MaxMachine).


createTasks(Tasks,MaxTask,MaxTask).
createTasks(Tasks,CurrentTask,MaxTask):-	append(Tasks,[task(Baseline,Duracao,Deadline,Consumo,IdMaquina,CurrentTask)],NewTasks),
											NewCurrentTask is CurrentTask + 1,
											createTasks(NewTasks,NewCurrentTask,MaxTask).


createTasksNotSchedulable(TasksNotSchedulable,MaxTask,MaxTask).
createTasksNotSchedulable(TasksNotSchedulable,CurrentTask,MaxTask):-	append(TasksNotSchedulable,[task(Baseline,Duracao,Deadline,Consumo,IdMaquina,CurrentTask)],NewTasksNotSchedulable),
																NewCurrentTask is CurrentTask + 1,
																createTasks(NewTasksNotSchedulable,NewCurrentTask,MaxTask).

% X = potencia contratada
limit(X).

%%determinar o limit disponivel para cada 30 min do dia com as TasksNotSchedulable




settingNotSchedulableTasks([TaskNotSchedulable|Rest],AllTasks,RemainingPowerTimeTable).




*/


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
		
		labeling([minimize(LimiteEnergetico)],Vars).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

calculaCustoTotal(_,[],CustoTotal,CustoTotal).

calculaCustoTotal(LCustos,[task(S,_,_,C,_)|NextTask],CustoActual,CustoTotal) :-
	element(S,LCustos,Custo),
	Mult #= Custo*C,
	CustoActual1 #= CustoActual + Custo*C,
	calculaCustoTotal(LCustos,NextTask,CustoActual1,CustoTotal).
		
		
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
% Sem considerar os não escalonaveis
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
		
		labeling([minimize(CustoLimite)],Vars).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%











