% ################################################# %
%                                                   %
%             Joao Miguel Campos, 75785             %
%                                                   %
% ################################################# %

:- include('SUDOKU').
% :- ['exemplos.pl'].

% ################################################# %
%                                                   %
%      Predicados para propagacao de mudancas       %
%                                                   %
% ################################################# %


% Base de recursao; Caso em que Cont e o a posicao em questao tem o mesmo valor.

puzzle_muda_propaga(Puz, Pos, Cont, Puz) :-
    puzzle_ref(Puz, Pos, Cont), !.


% Se o tamanho de Cont =:= 1, entao, vou propagar as mudancas efectuadas.
% Se se verificar que Cont pertence a algum conteudo Cont da lista de posicoes
% relacionadas Pos_Rel, entao removo Cont dessa lista e passo a proxima posicao.

puzzle_muda_propaga(Puz, Pos, [Num], New_Puz) :- !,
    puzzle_muda(Puz, Pos, [Num], N_Puz),
    posicoes_relacionadas(Pos, Pos_Rel),
    tira_num(Num, N_Puz, Pos_Rel, New_Puz).


% Tamanho de Cont =/= 1, entao e igual a puzzle_muda().

puzzle_muda_propaga(Puz, Pos, Cont, N_Puz) :-
    \+length(Cont, 0),
    \+length(Cont, 1),
    puzzle_muda(Puz, Pos, Cont, N_Puz).


% N_Puz e o puzzle resultante de retirar Num do conteudo de Pos.

tira_num_aux(Num, Puz, Pos, N_Puz) :-
    puzzle_ref(Puz, Pos, Cont),
    subtract(Cont, [Num], New_Cont),
    puzzle_muda_propaga(Puz, Pos, New_Cont, N_Puz).


% N_Puz e o puzzle resultante de retirar Num dos conteudos de
% todas as posicoes dadas em Posicoes.

tira_num(Num, Puz, Posicoes, N_Puz) :-
    percorre_muda_Puz(Puz, tira_num_aux(Num), Posicoes, N_Puz).


% ################################################# %
%                                                   %
%     Predicados para inicializacao de Puzzles      %
%                                                   %
% ################################################# %


%---------------------------------------------------------------------
% possibilidades_aux(Puz, Conteudos, L, Poss): recebe um Puz, uma lista com
% todos os conteudos da lista de posicoes, passado no predicado
% possibilidades(), recebe L, uma lista de 1 ate n, onde n e a dimensao do
% sudoku e devolve Poss, uma lista que contem as possibilidades
% para uma certa posicao, declarada no predicado possibilidades().
%---------------------------------------------------------------------


% Base de recursao.

possibilidades_aux(_, [],L, Result) :-
    append(L,[],Result),!.


% Caso em que, ao encontrar-se um conteudo que seja unitario, subtrai-se
% esse conteudo da lista L.

possibilidades_aux(Puz, [H|T], L, Result) :-
    length(H, 1),!,
    subtract(L, H, New_List),
    possibilidades_aux(Puz, T, New_List, Result).


% Caso em que se encontra um conteudo que nao e unitario.
% Assim, passamos a analisar o proximo conteudo.

possibilidades_aux(Puz, [H|T], L, Result) :-
    \+length(H, 1), !,
    possibilidades_aux(Puz, T, L, Result).


% A posicao Pos contem uma sequencia unitaria. Assim, nao acontece nada.

possibilidades(Pos, Puz, Poss) :-
    puzzle_ref(Pos, Puz, [Poss]).


% Poss devolve as possibilidades para a posicao Pos.
% Utiliza o predicado possibilidades_aux().

possibilidades(Pos, Puz, Poss) :-
    numeros(L),
    posicoes_relacionadas(Pos, Posicoes),
    conteudos_posicoes(Puz, Posicoes, Conteudos),
    possibilidades_aux(Puz, Conteudos, L, Poss).


% Conteudo Cont da posicao e unitario, nada e alterado.

inicializa_aux(Puz, Pos, N_Puz) :-
    puzzle_ref(Puz, Pos, Cont),
    length(Cont,1), !,
    append(Puz,[],N_Puz).


% Verifica as possibilidades para a posicao Pos, caso sejam diferentes
% da lista vazia, muda e propaga esta mudanca.

inicializa_aux(Puz, Pos, N_Puz) :-
    possibilidades(Pos, Puz, Poss),
    \+length(Poss, 0), !,
    puzzle_muda_propaga(Puz, Pos, Poss, N_Puz).


% N_Puz e o resultado de inicializar todas as posicoes de Puz.

inicializa(Puz, N_Puz) :-
    todas_posicoes(Todas_Pos),
    percorre_muda_Puz(Puz, inicializa_aux, Todas_Pos, N_Puz), !.



% ################################################# %
%                                                   %
%       Predicados para inspeccao de Puzzles        %
%                                                   %
% ################################################# %


%---------------------------------------------------------------------
% num_ocorrencias(Num, Conteudos, Posicoes, [Pos_Num]): recebe um Num, uma lista
% de conteudos, Conteudos, uma lista de Posicoes e devolve uma lista, Pos_Num,
% de posicoes onde ocorre o Num.
%---------------------------------------------------------------------


% Base de recursao.

num_ocorrencias(_, [], _, []) :- !.


% Num pertence ao conteudo em analise, entao a sua posicao e adicionada
%a lista final e analisa-se o proximo conteudo.

num_ocorrencias(Num, [Head_Cont|Tail_Cont], [Head_Pos|Tail_Pos], [Head_Pos|Tail_Pos_Aux]) :-
    member(Num,Head_Cont), !,
    num_ocorrencias(Num, Tail_Cont, Tail_Pos, Tail_Pos_Aux).


% Num nao pertence ao conteudo em analise, entao analisa-se o proximo conteudo.

num_ocorrencias(Num, [Head_Cont|Tail_Cont], [_|Tail_Pos], Tail_Pos_Aux) :-
    \+member(Num, Head_Cont),
    num_ocorrencias(Num, Tail_Cont, Tail_Pos, Tail_Pos_Aux).


% Se Num so ocorre uma vez em Posicoes, entao retorna a sua posicao.
% Caso contrario, retorna false.

so_aparece_uma_vez(Puz, Num, Posicoes, Pos_Num) :-
    conteudos_posicoes(Puz,Posicoes,Conteudos),
    num_ocorrencias(Num, Conteudos, Posicoes, [Pos_Num]).


% Se Num so ocorre numa das posicoes de Posicoes, e o conteudo dessa posicao
% nao e uma lista unitaria, chama o predicado puzzle_muda_propaga().

inspecciona_num(Posicoes, Puz, Num, N_Puz) :-
    so_aparece_uma_vez(Puz, Num, Posicoes, Pos_Num),
    puzzle_ref(Puz, Pos_Num, Cont),
    \+length(Cont, 1), !,
    puzzle_muda_propaga(Puz, Pos_Num, [Num], N_Puz).


% Caso contrario, Puz = N_Puz.

inspecciona_num(_, Puz, _, N_Puz) :- !,
    append(Puz, [], N_Puz).


% Inspecciona cada um dos conteudos da lista de Posicoes Gr.

inspecciona_grupo(Puz, Gr, N_Puz) :-
    numeros(L),
    percorre_muda_Puz(Puz, inspecciona_num(Gr), L , N_Puz).


% Inspecciona cada um dos grupos de posicoes da lista de grupos Gr.

inspecciona(Puz, N_Puz) :-
    grupos(Gr),
    percorre_muda_Puz(Puz, inspecciona_grupo, Gr, N_Puz), !.



% ################################################# %
%                                                   %
%      Predicados para verificacao de solucoes      %
%                                                   %
% ################################################# %


% Verifica se o grupo de posicoes Gr contem todos os os numeros da lista Nums.

grupo_correcto(Puz, Nums, Gr) :-
    conteudos_posicoes(Puz,Gr,Conteudos),
    flatten(Conteudos, Cont_Flat),
    msort(Cont_Flat, Nums).


% Se Puz for uma solucao, entao retorna true.
% Caso contrario, retorna False.

solucao(Puz) :-
    numeros(L),
    grupos(Gr),
    maplist(grupo_correcto(Puz, L), Gr).


%---------------------------------------------------------------------
% procura_posicoes(Puz, Todas_Pos, Sol): recebe um Puz, inspeccionado,
% e uma lista com todas as posicoes do puzzle, e devolve uma solucao Sol.
%---------------------------------------------------------------------

% Base de recursao.

procura_posicoes(Puz, [], Puz).


% Verifica se o Puz actual e solucao ou se e preciso modificar
% mais posicoes.

procura_posicoes(Puz, _, Puz) :-
    solucao(Puz), !.


% Se a posicao Head_Pos tiver como conteudo uma lista unitaria,
% entao avalia a proxima posição.

procura_posicoes(Puz, [Head_Pos|Tail_Pos], New_Puz) :-
    puzzle_ref(Puz, Head_Pos, Cont),
    length(Cont, 1),
    procura_posicoes(Puz, Tail_Pos, New_Puz).


% Se o conteudo da posicao Head_Pos nao for vazio,
% executa o predicado pos_para_cont(). Apos executado, procura-se nova posicao
% com conteudo nao unitario nem vazio.

procura_posicoes(Puz, [Head_Pos|Tail_Pos], New_Puz) :-
    puzzle_ref(Puz, Head_Pos, Cont),
    \+length(Cont, 0),
    pos_para_cont(Puz, Head_Pos, Cont, N_Puz),
    procura_posicoes(N_Puz, Tail_Pos, New_Puz).


%---------------------------------------------------------------------
% pos_para_cont(Puz, Pos, Cont, N_Puz): recebe um Puz, uma posicao Pos
% e uma lista de conteudos Cont, e vai testar cada uma das posicoes de
% Cont, para chegar a uma solucao.
%---------------------------------------------------------------------


% Base de recursao.

pos_para_cont(Puz, _, [], Puz).


% Muda o conteudo de Pos para Head_Cont e propaga-o.

pos_para_cont(Puz, Pos, [Head_Cont|_], New_Puz) :-
    puzzle_muda_propaga(Puz, Pos, [Head_Cont], New_Puz).


% Verifica se o proximo elemento dos conteudos, Tail_Cont, e vazio.
% Caso nao seja, vai ser o proximo valor a testar.

pos_para_cont(Puz, Pos, [_|Tail_Cont], Result) :-
    \+length(Tail_Cont, 0),
    pos_para_cont(Puz, Pos, Tail_Cont, Result).


% Caso em que o puzzle Puz ja esta completo.

resolve(Puz, Sol) :-
    inicializa(Puz, Puz_Inicializado),
    inspecciona(Puz_Inicializado, Sol),
    solucao(Sol), !.


% Caso onde vamos encontrar a solucao atraves de tentativa e erro.

resolve(Puz, Sol) :-

    inicializa(Puz, Puz_Inicializado),
    inspecciona(Puz_Inicializado, Puz_Inspeccionado),
    todas_posicoes(Todas_Pos),
    procura_posicoes(Puz_Inspeccionado, Todas_Pos, Sol),
    solucao(Sol), !.
