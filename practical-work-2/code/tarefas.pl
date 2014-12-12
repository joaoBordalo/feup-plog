%registo das tarefas

:- use_module(aparelhos).


%%%%
%% Todas as tarefas
%%%%

%tarefa(+Id,aparelho(+Id,+NomeEquipamento,+CurvaConsumo,+Escalonavel),+Baseline,+Deadline,+Duracao).

tarefa(1,aparelho(1,NomeEquipamento,CurvaConsumo,Escalonavel),Baseline,Deadline,Duracao).


%task(-Baseline,-Duracao,-Deadline,-Consumo,-IdMaquina).







%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%tarefas(+Atual_tarefa,+Total_tarefas,-Lista_tarefas)


create_tasks(Tasks,CurrenTask,NumberTasks):-
		append(Tasks,[task(_,_,_,_)])

tarefas(Total_tarefas,Total_Tarefas,_).
tarefas(Atual_tarefa,Total_tarefas,Lista_tarefas):- 	
													append(Lista_tarefas,tarefa(Atual_tarefa,_,_,_,_),New_lista_tarefas),
													New_atual_tarefa is Atual_tarefa + 1,
													tarefas(New_atual_tarefa,Total_tarefas,New_lista_tarefas).
