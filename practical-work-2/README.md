2º Projeto de Plog


11. Escalonamento de Dispositivos Elétricos

Algumas anotações:


Aparelhos escalonáveis: é possível definir uma janela temporal para seu funcionamento (ex máquinas de lavar, fornos, ou termoacumuladores)

Aparelhos não escalonáveis: impossível de definir um periodo de funcionamento


Tarefas: 

-Baseline: momento em que se pode dar início À tarefa( o mais cedo possível)
-Deadline: momento em que a tarefa tem de ser terminada ( o mais tarde possível)
-Duração: tempo necessário para executar a tarefa
-Curva de duração de consumo: evolução do consumo de energia em função do tempo(dependendo do dispositivo, pode o consumo pode ser variável ou constante, com conhecimento antecipado)


Preço da energia: 

-Preço varia ao longo do dia, consoate a hora do dia.


Potência contratada: 

-Consumo máximo permitido em qualquer hora do dia 


Previsão de consumo não escalonável: Tarefas em que há tempo fixo de início: deadline = inicio da taref + duração

Energia para escalonamento = Energia Contratada - Previsão de Consumo não escalonável

Objetivo: Obter o escalonamento das tarefas escalonáveis:

-O escalonamento das tarefas devem ser feitas numa janela temporal de 24h

-As tarefas devem ser executadas na janela temporal permitida isto é, entre o baseline e o deadline

-O consumo de energia não pode ultrapassar a energia disponível



Otimizações:

-Obter escalonamento com o menor custo a pagar pela energia ao longo do dia

-Obter o consumo mais uniforme possivel com o intuito de baixar a potência contratada



Aparelhos não escalonáveis: Frigorífico, Congelador, Arca frigorífica, Televisão, Luz por divisão 

Aparelhos escalonáveis: Máquina de lavar louça, Máquina de lavar roupa, Forno, Termoacumulador, Aquecedor



Tarefa(NomeEquipamento,Baseline,Deadline,Duracao,CurvaConsumo,Escalonável)

Equipamento(NomeEquipamento,CurvaConsumo,Escalonavel)

Escalonável(true or false)



Bibliografia:

http://www.pouparmelhor.com/praticas/consumo-mais-detalhado-de-uma-maquina-de-lavar-roupa/


http://www.siemens-home.pt/Files/SiemensNew/Pt/pt/2012/Cat%C3%A1logos/Siemens_cat%C3%A1logo%20loi%C3%A7a_Abril_2012.pdf


