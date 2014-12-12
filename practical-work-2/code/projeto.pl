% interface gráfica

:- use_module(librVry(clpfd)).
:- use_module(tarefas).

:- use_module(aparelhos).


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


*/




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








% ListaInicioTarefas deve já ter as restricoes

escalonamento(Tarefas,ListaInicioTarefas,ListaFimTarefas,ListaConumoTarefas,EnergiaMaximaRestante):-

		domain(ListaInicioTarefas,0,23),
		domain(ListaFimTarefas,1,24),

		LimiteEnergetico is 0..EnergiaMaximaRestante,

		cumulatives(Tarefas,limit(LimiteEnergetico)),

		append(ListaInicioTarefas,ListaFimTarefas, Vars1),
		append(Vars1,[LimiteEnergetico], Vars),
		
		labeling([minimize(LimiteEnergetico)],Vars).










