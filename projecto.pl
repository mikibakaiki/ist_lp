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


possibilidades_aux(Puz, [H|T], L, Result):-
    length(H, 1),
    % writeln("single"),
    subtract(L, H, New_List),
    % writeln(New_List),
    possibilidades_aux(Puz, T, New_List, Result).

possibilidades_aux(Puz, [H|T], L, Result):-
    \+length(H, 1),
    % writeln("not single"),
    possibilidades_aux(Puz, T, L, Result).

possibilidades_aux(_, [],L, Result):-
    append(L,[],Result).

 possibilidades(Pos, Puz, Poss) :-
    puzzle_ref(Pos, Puz, [Poss]).

possibilidades(Pos, Puz, Poss) :-
    numeros(L),
    posicoes_relacionadas(Pos, Posicoes),
    conteudos_posicoes(Puz, Posicoes, Conteudos),
    possibilidades_aux(Puz, Conteudos, L, Poss).

%
%----- ERROS -----
% devolve o P2, dunno why
%-----------------
%

inicializa_aux(Puz, Pos, N_Puz) :-
    puzzle_ref(Pos, Puz, [N_Puz]).


inicializa_aux(Puz, Pos, N_Puz) :-
    possibilidades(Pos, Puz, Poss),
    puzzle_muda(Puz, Pos, Poss, N_Puz).

inicializa(Puz, N_Puz) :-
    todas_posicoes(Todas_Pos),
    percorre_muda_Puz(Puz, inicializa_aux(), Todas_Pos, N_Puz).



    % ################################################# %
    %                                                   %
    %       Predicados para inspeccao de Puzzles        %
    %                                                   %
    % ################################################# %


num_ocor(_, [], 0).

num_ocor(Num, [H|T], Num_Ocor) :-
    member(Num, H),
    writeln(Num),
    writeln(H),
    writeln("member"),
    num_ocor(Num, T, Num_Ocor_Aux),
    Num_Ocor is Num_Ocor_Aux + 1.


num_ocor(Num, [H|T], Num_Ocor) :-
    \+member(Num, H),
    writeln(Num),
    writeln(H),
    writeln("not member"),
    num_ocor(Num, T, Num_Ocor).



return_pos(Puz, Num,[H|T], Pos_Num) :-
    puzzle_ref(Puz, H, Cont),
    \+member(Num, Cont),
    return_pos(Puz, Num, T, Pos_Num).

return_pos(Puz, Num, [H|_], Pos_Num) :-
    puzzle_ref(Puz, H, Cont),
    member(Num, Cont),
    return_pos(Puz, _, H, Pos_Num).

return_pos(_, _, Pos, Pos_Num) :-
    Pos_Num is Pos.


so_aparece_uma_vez(Puz, Num, Posicoes, Pos_Num) :-
    conteudos_posicoes(Puz,Posicoes,Conteudos),
    num_ocor(Num, Conteudos, Ocorrencias),
    Ocorrencias =:= 1,
    return_pos(Puz, Num, Posicoes, Pos_Num).



% so_aparece_uma_vez(Puz, Num, Posicoes, Pos_Num):-
%     writeln("caso inicial"),
%     so_aparece_uma_vez(Puz, Num, Posicoes, Pos_Num, 0).
%
% % so_aparece_uma_vez(Puz, Num, [H|T], Pos_Num, Cont):-
% %     puzzle_ref(Puz, H, [Num]),
% %     Cont1 is Cont + 1,
% %     so_aparece_uma_vez(Puz, Num, T, Pos_Num, Cont1).
%
% so_aparece_uma_vez(Puz, Num, [H|T], Pos_Num, Cont):-
%     puzzle_ref(Puz, H, Conteudo),
%     member(Num, Conteudo),
%     Cont1 is Cont + 1,
%     so_aparece_uma_vez(Puz, Num, T, Pos_Num, Cont1).
%
% so_aparece_uma_vez(Puz, Num, [H|T], Pos_Num, Cont) :-
%     puzzle_ref(Puz, H, Conteudo),
%     \+member(Num, Conteudo),
%     so_aparece_uma_vez(Puz, Num, T, Pos_Num, Cont).
%
% so_aparece_uma_vez(Puz, Num, [H|T], )
%
%
% so_aparece_uma_vez(Puz, Num, [H|T], Pos_Num, Cont):-
%     writeln("caso 1"),
%     possibilidades(H, Puz, Possiveis),
%     member(Num, Possiveis),
%     Cont < 1,
%     writeln("cont < 1"),
%     Cont1 is Cont + 1,
%     so_aparece_uma_vez(Puz, Num, T, Pos_Num, Cont1, H).
%
% so_aparece_uma_vez(Puz, Num, [_|T], Pos_Num, Cont):-
%     writeln("analisar proximo membro"),
%     so_aparece_uma_vez(Puz,Num,T,Pos_Num,Cont).
%
% so_aparece_uma_vez(Puz, Num, [H|T], Pos_Num, Cont, Aux):-
%     writeln("ja tenho uma posicao"),
%     possibilidades(H,Puz,Possiveis),
%     \+member(Num,Possiveis),
%     writeln("nao sou membro"),
%     so_aparece_uma_vez(Puz, Num, T, Pos_Num, Cont, Aux).
%
% so_aparece_uma_vez(Puz, Num, [H|_], _, _, _):-
%     possibilidades(H,Puz,Possiveis),
%     member(Num,Possiveis),
%     writeln("sou membro").
%
% so_aparece_uma_vez(_,_, [],Pos_Num,Cont,Aux):-
%     writeln("fim"),
%     Cont =:= 1,
%     append(Aux,[],Pos_Num).
%
%
% so_aparece_uma_vez(Puz, Num, Posicoes, Pos_Num) :-
%     so_aparece_uma_vez(Puz, Num, Posicoes, Pos_Num, 0).
%
% so_aparece_uma_vez(Puz, Num, [H|T], Pos_Num, Cont) :-
%     Cont < 2,
%     member(Num,H),
%     append(H,[],Cont),
%     Cont1 is Cont + 1,
%     so_aparece_uma_vez(Puz,Num,T,Pos_Num,Cont1).
%
% so_aparece_uma_vez(Puz, Num, [_|T], Pos_Num, Cont):-
%     Cont < 2,
%     so_aparece_uma_vez(Puz,Num,T,Pos_Num,Cont).
%
% so_aparece_uma_vez(_,_,[],Pos_Num,_):-
%     append()


/*inspecciona_num(Posicoes, Puz, Num, N_Puz) :-
    grupo(Gr).

inspecciona_grupo(Puz, Gr, N_Puz) :-
    numeros(L),
    percorre_muda_Puz(Puz, inspecciona_num(Gr), L , N_Puz).


inspecciona(Puz, N_Puz) :-
    percorre_muda_Puz(Puz, inspecciona_grupos(), Gr, N_Puz).*/
