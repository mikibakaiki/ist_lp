% ################################################# %
%                                                   %
%             Joao Miguel Campos, 75785             %
%                                                   %
% ################################################# %


:- include('SUDOKU').
:-['exemplos.pl'].


% Base de recursao; Caso em que Cont e o a posicao em questao tem o mesmo valor.

puzzle_muda_propaga(Puz, Pos, Cont, Puz) :-
    puzzle_ref(Puz, Pos, Cont).

% Se o tamanho de Cont =:= 1, entao, vou propagar.
% Mudo o conteudo da posicao Pos por Cont, e devolvo o novo puzzle, N_Puz_Aux.
% Para propagar, chamo o predicado posicoes_relacionadas, que me diz quais as posicoes
% relacionadas, Pos_Rel, com a posicao Pos em analise.
% Por fim, vou verificar se Cont pertence a alguma posicao da lista Pos_Rel.
% Se sim, entao removo da lista e passo a proxima posicao.

puzzle_muda_propaga(Puz, Pos, [Num], New_Puz) :- !,
    puzzle_muda(Puz, Pos, [Num], N_Puz),
    posicoes_relacionadas(Pos, Pos_Rel),
    tira_num(Num, N_Puz, Pos_Rel, New_Puz).

% Tamanho de Cont =/= 1, entao e igual a puzzle_muda().

puzzle_muda_propaga(Puz, Pos, Cont, N_Puz) :-
    puzzle_muda(Puz, Pos, Cont, N_Puz).

tira_num_aux(Num, Puz, Pos, N_Puz) :-
    puzzle_ref(Puz, Pos, Cont),
    subtract(Cont, [Num], Cont1),
    puzzle_muda_propaga(Puz, Pos, Cont1, N_Puz).

tira_num(Num, Puz, Posicoes, N_Puz) :-
    percorre_muda_Puz(Puz, tira_num_aux(Num), Posicoes, N_Puz).

%
