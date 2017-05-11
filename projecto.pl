    % ################################################# %
    %                                                   %
    %             Joao Miguel Campos, 75785             %
    %                                                   %
    % ################################################# %


:- include('SUDOKU').
:- ['exemplos.pl'].


    % ################################################# %
    %                                                   %
    %      Predicados para propagacao de mudancas       %
    %                                                   %
    % ################################################# %


% Base de recursao; Caso em que Cont e o a posicao em questao tem o mesmo valor.

puzzle_muda_propaga(Puz, Pos, Cont, Puz) :-
    puzzle_ref(Puz, Pos, Cont), !.

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


    % ################################################# %
    %                                                   %
    %     Predicados para inicializacao de Puzzles      %
    %                                                   %
    % ################################################# %

possibilidades_aux(_, [],L, Result):-
    append(L,[],Result),!.

possibilidades_aux(Puz, [H|T], L, Result):-
    length(H, 1),!,
    % writeln("single"),
    subtract(L, H, New_List),
    % writeln(New_List),
    possibilidades_aux(Puz, T, New_List, Result).

possibilidades_aux(Puz, [H|T], L, Result):-
    \+length(H, 1), !,
    % writeln("not single"),
    possibilidades_aux(Puz, T, L, Result).

possibilidades(Pos, Puz, Poss) :-
    puzzle_ref(Pos, Puz, [Poss]).

possibilidades(Pos, Puz, Poss) :-
    numeros(L),
    posicoes_relacionadas(Pos, Posicoes),
    conteudos_posicoes(Puz, Posicoes, Conteudos),
    possibilidades_aux(Puz, Conteudos, L, Poss).


inicializa_aux(Puz, Pos, N_Puz) :-
    % writeln("inicializa_aux p/ verificar se tem length 1"),
    puzzle_ref(Puz, Pos, Cont),
    length(Cont,1),
    % writeln(Puz),
    append(Puz,[],N_Puz).

inicializa_aux(Puz, Pos, N_Puz) :-
    % writeln("Segundo inicializa_aux"),
    possibilidades(Pos, Puz, Poss),
    % writeln(Poss),
    puzzle_muda_propaga(Puz, Pos, Poss, N_Puz).


inicializa(Puz, N_Puz) :-
    todas_posicoes(Todas_Pos),
    percorre_muda_Puz(Puz, inicializa_aux, Todas_Pos, N_Puz).



    % ################################################# %
    %                                                   %
    %       Predicados para inspeccao de Puzzles        %
    %                                                   %
    % ################################################# %

num_ocor_2(_, [], _, []).

num_ocor_2(Num, [H|T], [P|R], [P|R1]):-
    member(Num,H), !,
    num_ocor_2(Num, T, R, R1).

num_ocor_2(Num, [H|T], [_|R], R1) :-
    \+member(Num, H),
    num_ocor_2(Num, T, R, R1).

so_aparece_uma_vez(Puz, Num, Posicoes, Pos_Num) :-
    conteudos_posicoes(Puz,Posicoes,Conteudos),
    num_ocor_2(Num, Conteudos, Posicoes, [Pos_Num]).

inspecciona_num(Posicoes, Puz, Num, N_Puz) :-
    so_aparece_uma_vez(Puz, Num, Posicoes, Pos_Num),
    puzzle_ref(Puz, Pos_Num, Cont),
    \+length(Cont, 1),
    puzzle_muda_propaga(Puz, Pos_Num, [Num], N_Puz).

inspecciona_num(_, Puz, _, N_Puz) :-
    append(Puz, [], N_Puz).

inspecciona_grupo(Puz, Gr, N_Puz) :-
    numeros(L),
    percorre_muda_Puz(Puz, inspecciona_num(Gr), L , N_Puz).

inspecciona(Puz, N_Puz) :-
    grupos(Gr),
    percorre_muda_Puz(Puz, inspecciona_grupo, Gr, N_Puz).


    % ################################################# %
    %                                                   %
    %      Predicados para verificacao de solucoes      %
    %                                                   %
    % ################################################# %


grupo_correcto(Puz, Nums, Gr) :-
    conteudos_posicoes(Puz,Gr,Conteudos),
    flatten(Conteudos, Cont_Flat),
    msort(Cont_Flat, Nums).

solucao(Puz) :-
    numeros(L),
    grupos(Gr),
    maplist(grupo_correcto(Puz, L), Gr).
