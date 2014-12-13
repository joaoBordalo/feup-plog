get_todos_dispositivos(Lista):-
	write('Dispositivos na Base de Conhecimento: '),
	findall(Nome-Id-X, escalonavel(Nome,Id, X), Lista1),
	findall(Nome-X , nescalonavel(Nome,X), Lista2),
	append(Lista1, Lista2, Lista).
get_todos_dispositivos(_):- write('Nao existem dispositivos').

get_todos_escalonaveis(Lista):-
	write('Dispositivos na Base de Conhecimento: '),
	findall(Nome-Id-Consumo, escalonavel(Nome, Id, Consumo), Lista).
get_todos_escalonaveis(_):- write('Nao existem nescalonaveis').
	
	
get_todos_nomes_dispositivos(Lista):-
	findall(Nome, dispositivos(Nome, _), Lista).


get_todas_tarefas(Lista):-
	write('Tarefas na Base de Conhecimento: '), nl,
	findall(Nome-Idmaq-Baseline-Deadline-Duracao-Subtarefas, tarefa(Nome, Idmaq ,Baseline,Deadline,Duracao, Subtarefas), Lista).
get_todas_tarefas(_):- write('Nao existem tarefas').	


		%% LEE		%Lista de consumos de dispositivos esc.
		%% LED		%Lista de energias disponíveis no decorrer de 24 horas
		%% PotMax	%Potencia contratada por defeito
		%% EMax		%Potência contratada com n esc.
		%% EMaxCalc	%Potência contratada optimizada
		%% LS		%Lista de starting times
		%% LD		%Lista de durações de dispositivos esc.
		%% LE		%Lista de ending times
		%% Machines	%Lista das máquinas
		%% Tasks	%Lista das Tarefas
		
		cria_lista_disponivel(LED):-
			findall(Potenciacontratada, potenciacontratada(Potenciacontratada), [Pot|_]),
			(for(X,1,24), foreach(I,LED) do I is Pot).
		
		cria_lista_consumo(LEE):-
			findall(Consumo, subtask(_,_,_,Consumo,_), LEE).
		
		cria_lista_starting(LS):-
			findall(St,subtask(St,_,_,_,_), LS).
		
		cria_lista_duracao(LD):-
			findall(Duracao, subtask(_,Duracao,_,_,_), LD).
			
		cria_lista_ending(LE):-
			findall(Et,subtask(_,_,Et,_,_), LE).
			
		cria_lista_machines(Machines,EMax):-
			findall(machine(Id, EMax), escalonavel(_,Id, Recursos), Machines). 
			
		cria_lista_tasks(Tasks):-
			findall(task(Start,Dur,End,Consumo,Idmaq), subtask(Start, Dur, End, Consumo, Idmaq), Tasks).
		
		cria_lista_n_escalonavel(LNE):-
			findall(Consumo, nescalonavel( _, Consumo), LNE).
		
		get_pot_max(PotMax):-
			findall(Potenciacontratada, potenciacontratada(Potenciacontratada), [Pot|_]),
			PotMax is Pot.
		
		get_custos(LCustos) :-
			findall(Custo,custo(Custo),LCustos).