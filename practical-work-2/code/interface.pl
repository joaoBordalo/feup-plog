
:-use_module(library(clpfd)). 
:-use_module(library(lists)).

:-include('escalonamentos.pl').
:-include('listagens.pl').


:- dynamic escalonavel/3.
:- dynamic nescalonavel/2.
:- dynamic tarefa/6.
:- dynamic potenciacontratada/1.
:- dynamic subtask/5.
:- dynamic custo/1.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                      %%%
%%%       INTERFACE      %%%
%%%                      %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%


start :-
	write('CONFIGS INICIAIS'),
	nl,
	write('Introduza a potencia Contratada em W'),
	nl,
	read(Potenciacontratada),
	assert(potenciaContratada(Potenciacontratada)),
	startmenu.



startmenu :-
set_prolog_flag(fileerrors,off),
nl, intro, nl, nl,
	write('1 - Mostrar todos os Dispositivos'), nl,
	write('2 - Mostrar todas as Tarefas'), nl,
	write('3 - Criar Dispositivo'), nl,
	write('4 - Criar Tarefa'), nl,
	write('5 - Importar Dispositivos do ficheiro'), nl,
	write('6 - Importar Tarefas do ficheiro'), nl,
	write('7 - Gerar Escalonamento'), nl,
	write('8 - Limpar Base de Conhecimento'), nl,
	write('9 - Configurar Preco de Energia'),nl,
	write('10 - Importar config de preco de energia do ficheiro'),nl,
	write('11 - Calcular Otimizacao do Custo'),nl,
	write('0 - Sair'),nl,
	repeat, read(Op), Op >= 0, Op =< 11,!,
	menu(Op), repeat, skip_line, get_code(_), startmenu.



menu(0):- 
abort.

menu(1):-
	mostra_todos_dispositivos,
	nl,	
	mostra_todas_tarefas.

menu(1):-
	mostra_todos_dispositivos,
	startmenu.

menu(2):-
	mostra_todas_tarefas,
	startmenu.


menu(3):-
	write('1 - Dispositivo Escalonável'), nl,
	write('2 - Dispositivo não escalonável'), nl,
	write('0 - Voltar ao menu anterior'),nl,
	repeat, read(Op), Op >= 0, Op =< 2,!,
	menu_disp(Op), repeat, skip_line, get_code(_), menu(4).
	

menu(4):-
	write('Adicionar Tarefa(minusculas e terminado com  \'.\' ):'),nl,
	write('Nome da Tarefa:'),read(Nome),
	get_todos_escalonaveis(Lista),
	mostra_dispositivos(Lista),
	write('id (numero inteiro) da Maquina a associar :'), read(Idmaq),
	write('Baseline:'),read(Baseline),
	write('Deadline:'),read(Deadline),
	write('Duraçao:'), read(Duracao),
	divide_tarefas(Duracao, _, Idmaq, _,SubtarefasFinal),
	write(SubtarefasFinal),
	
	assert(tarefa(Nome, Idmaq ,Baseline,Deadline,Duracao, SubtarefasFinal)),
	write('Tarefa '),write(Nome), write(' de Baseline '), write(Baseline),write(', com Deadline as '),
	write(Deadline), write(' que dura '), write(Duracao),write(' adicionado com sucesso à base de conhecimento.').

divide_tarefas(0, SubtarefasFinal, _, _,SubtarefasFinal).
divide_tarefas(Duracao, Subtarefas, Idmaq, S1,SubtarefasFinal):-
	write('consumo na '), write(Duracao), write('º hora:'), read(Consumo), nl,
	assert(subtask(S1, 1, E1, Consumo, Idmaq)),
	append(Subtarefas,[Consumo],Subtarefas1),
	
	Duracao1 is Duracao - 1,
	divide_tarefas(Duracao1, Subtarefas1, Idmaq, E1,SubtarefasFinal).
	

menu(5):-
	write('Adicionar dispositivos do Ficheiro (\'root\\\\path\\\\dispositivos.txt\'):'),nl,
	repeat, read(Ficheiro),
	adiciona_dispositivos_do_ficheiro(Ficheiro),
	!.

menu(6):-
	write('Adicionar tarefas do ficheiro (\'root\\\\path\\\\tarefa.txt\'):'),nl,
	repeat,read(Ficheiro),
	adiciona_tarefas_do_ficheiro(Ficheiro),
	!.

menu(7):-
	write('1 - Escalonamento Por Consumo Energetico'), nl,
	write('2 - Escalonamento Pelo Custo Minimo'), nl,
	write('3 - Escalonamento Por Consumo Energetico Com Potencia Contratada Restante Variavel'),nl,
	write('4 - Escalonamento Pelo Custo Minimo Com Potencia Contratada Restante Variavel'),nl,
	write('0 - Voltar ao menu anterior'),nl,
	repeat, read(Op), Op >= 0, Op =< 4,!,
	menu_escal(Op), repeat, skip_line, get_code(_), menu(7).

menu(8):- 
	retractall(nescalonavel(_,_)),
	retractall(escalonavel(_,_,_)),
	write('Todos os dispositivos instanciados foram eliminados com sucesso!'), nl,
	retractall(tarefa(_,_,_,_,_,_)),
	write('Todas as tarefas instanciadas foram eliminadas com sucesso!'), nl.
	
	
menu(9):-
	write('Inserir preço hora a hora (inteiro terminado por ponto) 24 vezes'),nl,
	cria_lista_custo(24, Lista),
	write(Lista),nl,
	assert(custo(Lista)),
	write('Custo por hora confifurado com sucesso!!'),nl.
	

	

cria_lista_custo(0,Lista).
cria_lista_custo(Dias, Lista):-
	write('preço:'),
	read(X),nl,
	append(Lista, [X], Lista1),
	Dias1 is Dias - 1,
	cria_lista_custo(Dias1, Lista1).
	

menu(10):-
	write('Adicionar custo de energia do ficheiro (\'root\\\\path\\\\energia.txt\'):'),nl,
	write('ex.: \'\\\\\\\\samba.fe.up.pt\\\\ei07122\\\\plog\\\\energia.txt\''),nl,
	repeat,read(Ficheiro),
	adiciona_energia_do_ficheiro(Ficheiro),
	!.
	
		
menu(11):-
	gera_escalonamento_custo.
	
adiciona_energia_do_ficheiro(Ficheiro):-
	file_to_list(Ficheiro, Custos),
	write(Custos),nl,
	assert(custo(Custos)),
	write('custos adicionados com sucesso').





%%---------------------------------------------------------------------------------------------------------------------------------------
%%Menu dos Dispositivos

menu_disp(0):-startmenu.
	
menu_disp(1):-
	write('Adicionar Dispositivo Escalonável(minusculas e terminado com  \'.\' ):'),nl,
	write('Nome do Dispositivo:'),read(Nome),
	write('Id:'),read(Id),
	write('Recursos Alocados:'), read(X),
	assert(escalonavel(Nome,Id, X)),
	write('Dispositivo Escalonável '),write(Nome), write(' com id '), write(Id),write(' adicionado com sucesso à base de conhecimento.').
	
menu_disp(2):-
	write('Adicionar Dispositivo não Escalonável(minusculas e terminado com  \'.\' ):'),nl,
	write('Nome do Dispositivo:'),read(Nome),
	write('Consumo:'),read(Consumo),
	assert(nescalonavel(Nome,Consumo)),
	write('Dispositivo não Escalonável '),write(Nome), write(' com consumo de '), write(Consumo),write(' adicionado com sucesso à base de conhecimento.').	
	


%%-------------------------------------------------------------------------------------------------------------------------------------

%%Menu dos escalonamentos

menu_escal(0):-startmenu.


menu_escal(1):-

findall(Subtarefas,tarefa(_,_,_,_,_, Subtarefas),ListaConsumos),

		(	foreach(T,ListaConsumos),
			foreach(A,AmountSubtasks),
			count(I,1,N)
			do
				getLength(T,A),
				true
		),
		
		findall(Baseline,tarefa(_,_,Baseline,_,_,_),ListaBaselines),
		(	foreach(T,ListaBaselines),
			count(I,1,N)
			do
				true
		),
		
		findall(Deadline,tarefa(_,_,_,Deadline,_,_),ListaDeadlines),
		(	foreach(T,ListaDeadlines),
			count(I,1,N)
			do
				true
		),
		geraLines(ListaBaselines,_,Baselines,ListaDeadlines,_,Deadlines,AmountSubtasks),
		write(Baselines),write('\n'),
		write(Deadlines),write('\n'),
		
		findall(subtask(_,_,_,_,_),subtask(_,_,_,_,_),ListaSubT),	%% numero de subtarefas existentes
		(	foreach(_,ListaSubT),
			count(I,1,NS)
			do
				true
		),
		
		length(ListaInicioTarefas,NS),
		length(ListaFimTarefas,NS),
		
		separaTasks(ListaConsumos,_,Tasks,_,ListaInicioTarefas,_,ListaFimTarefas),


		cria_lista_n_escalonavel(LNE),
		
		get_pot_max(PotMax),
		calculaEmax(PotMax,PotenciaContratadaRestante,LNE),


escalonamentoPorConsumoEnergetico(ListaInicioTarefas,ListaFimTarefas,Tarefas,PotenciaContratadaRestante).

menu_escal(2):-

		get_custos([Custos|_]),
		
		findall(Subtarefas,tarefa(_,_,_,_,_, Subtarefas),ListaConsumos),
		(	foreach(T,ListaConsumos),
			foreach(A,AmountSubtasks),
			count(I,1,N)
			do
				getLength(T,A),
				true
		),
		
		findall(Baseline,tarefa(_,_,Baseline,_,_,_),ListaBaselines),
		(	foreach(T,ListaBaselines),
			count(I,1,N)
			do
				true
		),
		
		findall(Deadline,tarefa(_,_,_,Deadline,_,_),ListaDeadlines),
		(	foreach(T,ListaDeadlines),
			count(I,1,N)
			do
				true
		),
		geraLines(ListaBaselines,_,Baselines,ListaDeadlines,_,Deadlines,AmountSubtasks),
		write(Baselines),write('\n'),
		write(Deadlines),write('\n'),
		
		findall(subtask(_,_,_,_,_),subtask(_,_,_,_,_),ListaSubT),	%% numero de subtarefas existentes
		(	foreach(_,ListaSubT),
			count(I,1,NS)
			do
				true
		),
		
		length(ListaInicioTarefas,NS),
		length(ListaFimTarefas,NS),
		
		separaTasks(ListaConsumos,_,Tasks,_,ListaInicioTarefas,_,ListaFimTarefas),

		cria_lista_n_escalonavel(LNE),
		
		get_pot_max(PotMax),
		calculaEmax(PotMax,PotenciaContratadaRestante,LNE),


		escalonamentoPeloCustoMinimo(ListaInicioTarefas,ListaFimTarefas,Tarefas,PotenciaContratadaRestante, Custo).

menu_escal(3):-

findall(Subtarefas,tarefa(_,_,_,_,_, Subtarefas),ListaConsumos),

		(	foreach(T,ListaConsumos),
			foreach(A,AmountSubtasks),
			count(I,1,N)
			do
				getLength(T,A),
				true
		),
		
		findall(Baseline,tarefa(_,_,Baseline,_,_,_),ListaBaselines),
		(	foreach(T,ListaBaselines),
			count(I,1,N)
			do
				true
		),
		
		findall(Deadline,tarefa(_,_,_,Deadline,_,_),ListaDeadlines),
		(	foreach(T,ListaDeadlines),
			count(I,1,N)
			do
				true
		),
		geraLines(ListaBaselines,_,Baselines,ListaDeadlines,_,Deadlines,AmountSubtasks),
		write(Baselines),write('\n'),
		write(Deadlines),write('\n'),
		
		findall(subtask(_,_,_,_,_),subtask(_,_,_,_,_),ListaSubT),	%% numero de subtarefas existentes
		(	foreach(_,ListaSubT),
			count(I,1,NS)
			do
				true
		),
		
		length(ListaInicioTarefas,NS),
		length(ListaFimTarefas,NS),
		
		separaTasks(ListaConsumos,_,Tasks,_,ListaInicioTarefas,_,ListaFimTarefas),


		cria_lista_n_escalonavel(LNE),
		
		get_pot_max(PotMax),
		calculaListaEmax(PotMax,PotenciaContratadaRestante,LNE),

escalonamentoPorConsumoEnergeticoComPotenciaContratadaRestanteVariavel(ListaInicioTarefas,ListaFimTarefas,Tarefas,ListaPotenciaContratadaRestante).

menu_escal(4):-

get_custos([Custos|_]),
		
		findall(Subtarefas,tarefa(_,_,_,_,_, Subtarefas),ListaConsumos),
		(	foreach(T,ListaConsumos),
			foreach(A,AmountSubtasks),
			count(I,1,N)
			do
				getLength(T,A),
				true
		),
		
		findall(Baseline,tarefa(_,_,Baseline,_,_,_),ListaBaselines),
		(	foreach(T,ListaBaselines),
			count(I,1,N)
			do
				true
		),
		
		findall(Deadline,tarefa(_,_,_,Deadline,_,_),ListaDeadlines),
		(	foreach(T,ListaDeadlines),
			count(I,1,N)
			do
				true
		),
		geraLines(ListaBaselines,_,Baselines,ListaDeadlines,_,Deadlines,AmountSubtasks),
		write(Baselines),write('\n'),
		write(Deadlines),write('\n'),
		
		findall(subtask(_,_,_,_,_),subtask(_,_,_,_,_),ListaSubT),	%% numero de subtarefas existentes
		(	foreach(_,ListaSubT),
			count(I,1,NS)
			do
				true
		),
		
		length(ListaInicioTarefas,NS),
		length(ListaFimTarefas,NS),
		
		separaTasks(ListaConsumos,_,Tasks,_,ListaInicioTarefas,_,ListaFimTarefas),

		cria_lista_n_escalonavel(LNE),
		
		get_pot_max(PotMax),
		calculaListaEmax(PotMax,PotenciaContratadaRestante,LNE),


		escalonamentoPeloCustoMinimo(ListaInicioTarefas,ListaFimTarefas,Tarefas,PotenciaContratadaRestante, Custo).


escalonamentoPeloCustoMinimoComPotenciaContratadaRestanteVariavel(ListaInicioTarefas,ListaFimTarefas,Tarefas,ListaPotenciaContratadaRestante, Custo).




calculaListaEmax(PotMax,PotenciaContratadaRestante,[]).

calculaListaEmax(PotMax,PotenciaContratadaRestante,[H|T]):-
		PotMaxNext is PotMax - H,
		append(PotenciaContratadaRestante,[PotMaxNext],EMax)
		calculaEmax(PotMax,EMax,T).


	
mostra_todos_dispositivos:-
	get_todos_dispositivos(Dispositivos),
	nl, 
	mostra_dispositivos(Dispositivos).
	
mostra_dispositivos([]):- write('Fim dos Dispositivos'), nl.
mostra_dispositivos([Este_dispositivo|Outros_dispositivos]):-
	write(Este_dispositivo), nl,
	mostra_dispositivos(Outros_dispositivos).

	
mostra_todas_tarefas:-
	get_todas_tarefas(Tarefas),
	nl, 
	mostra_tarefas(Tarefas).

mostra_tarefas([]):- write('Fim das Tarefas'), nl.
mostra_tarefas([Esta_tarefa|Outras_tarefas]):-
	write(Esta_tarefa),nl,
	mostra_tarefas(Outras_tarefas).
	
%%--------------------------------------------------------------------------------------
	
%----------------------------------------------
%% SINTAXE DO FICHEIRO DE DISPOSITIVOS
%% 1 Disp por linha
%% 'Nome1. Consumo1.'
%% 'Nome2. Consumo2.'
%%
%-------------------------------------------------
	
adiciona_dispositivos_do_ficheiro(Ficheiro):-
	file_to_list(Ficheiro, Dispositivos),
	write(Dispositivos),nl,
	importar_dispositivos_para_kb(Dispositivos),
	write('Dispositivos importados!!').
	
importar_dispositivos_para_kb([]).	
importar_dispositivos_para_kb([Nome,Consumo|Proximo]):-
	assert(dispositivo(Nome, Consumo)),
	write('fez assert'), nl,
	importar_dispositivos_para_kb(Proximo).
	
	
%----------------------------------------------
%% SINTAXE DO FICHEIRO DE TAREFAS
%% 1 Disp por linha
%% 'Nome1. Idmaq1, Baseline1. Deadline1. Duracao1. [consumos].'
%%  
%%
%-------------------------------------------------
	
adiciona_tarefas_do_ficheiro(Ficheiro):-
	file_to_list(Ficheiro, Tarefas),
	write(Tarefas),nl,
	importar_tarefas_para_kb(Tarefas),
	write('Tarefas importadas!!').

brinca_consumos([],_).	
brinca_consumos([Consumo|Nconsumo], Idmaq):-
assert(subtask(S1, 1, E1, Consumo, Idmaq)),
brinca_consumos(Nconsumo, Idmaq).

	
importar_tarefas_para_kb([]).	
importar_tarefas_para_kb([Nome,Idmaq, Baseline, Deadline, Duracao, Consumos|Proximo]):-
	write('unificou'),nl,
	assert(tarefa(Nome, Idmaq ,Baseline,Deadline,Duracao, Consumos)),
	brinca_consumos(Consumos, Idmaq),
	write('fez assert das tarefas'),nl,
	importar_tarefas_para_kb(Proximo).
	
	
file_to_list(FILE,LIST) :- 
   see(FILE), 
   inquire([],R),
   reverse(R,LIST),
   seen.

inquire(IN,OUT):-
   read(Data), 
   (Data == end_of_file -> 
      OUT = IN 
        ;    % more
      inquire([Data|IN],OUT) ) .
