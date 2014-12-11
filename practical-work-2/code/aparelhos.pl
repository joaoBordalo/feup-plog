%registo dos aparelhos


%%%%
%% Todos os aparelhos
%%%%

%aparelho(+Id,+NomeDoAparelho,+CurvaConsumo, Escalonavel) CurvaConsumo em kWh, inicialmente assumir que é constante durante a sua utilização
%Escalonavel=0 =>nao Escalonável; Escalonavel=1 =>Escalonavel


aparelho(1,'Maquina de Lavar Roupa',25,1).
aparelho(2,'Maquina de Lavar Louça',67,1).
aparelho(3,'Televisao', 3,0).
aparelho(4,'Forno', 17,1).
aparelho(5,'Aquecedor',7,1).
aparelho(6,'Frigorífico' 10,0).