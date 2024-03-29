exemplo_puzzle(1, [[[2,4,8],[3],[2,7,8,9],[2,5,6,7,9],[2,4,6,7,8,9],[1],[2,4,6,7],[4,7],[4,6,7]],
[[2,4,8],[4,7,9],[6],[2,3,7,9],[2,3,4,7,8,9],[2,3,4,7,8,9],[1,2,4,7],[5],[1,4,7]],
[[5],[4,7],[1],[2,6,7],[2,4,6,7],[2,4,7],[9],[8],[3]],
[[1,4],[8],[5,7],[1,7,9],[1,4,7,9],[6],[3],[1,4,7,9],[2]],
[[1,2,4,6],[4,6,7],[2,7],[1,2,3,7,9],[5],[2,3,4,7,9],[1,4,7],[1,4,7,9],[1,4,7,8]],
[[9],[4,5,7],[3],[8],[1,2,4,7],[2,4,7],[1,4,5,7],[6],[1,4,5,7]],
[[7],[1],[4],[3,5,6],[3,6,8],[3,5,8],[5,6],[2],[9]],
[[3,6],[2],[5,9],[1,3,5,6,7,9],[1,3,6,7,9],[3,5,7,9],[8],[1,4,7],[1,4,5,6,7]],
[[6,8],[5,6,9],[5,8,9],[4],[1,2,6,7,8,9],[2,5,7,8,9],[1,5,6,7],[3],[1,5,6,7]]]).

exemplo_puzzle(2,[[[1],[9],[7],[4],[3],[8],[5],[2],[6]],
[[2],[6],[5],[7],[1],[9],[3],[8],[4]],
[[4],[3,8],[3,8],[6],[2],[5],[1,9],[1,7],[7,9]],
[[8],[2,5],[1,9],[2,5],[6],[1,7],[4],[3],[5,7,9]],
[[5,7,9],[2,3,5],[1,3,9],[8],[4],[1,7],[2,9],[6],[5,7,9]],
[[5,7],[4],[6],[2,5],[9],[3],[1,2],[1,7],[8]],
[[5,9],[5,8],[8,9],[3],[7],[2],[6],[4],[1]],
[[6],[1],[2],[9],[8],[4],[7],[5],[3]],
[[3],[7],[4],[1],[5],[6],[8],[9],[2]]]).

exemplo_puzzle(4,[[[],[],[7],[9],[6],[2],[4],[],[]],
[[9],[],[],[],[1],[],[],[],[2]],
[[],[1],[],[8],[5],[3],[],[6],[]],
[[5],[],[],[4],[7],[9],[],[],[1]],
[[],[],[],[],[8],[],[],[],[]],
[[4],[],[],[3],[2],[1],[],[],[7]],
[[],[9],[],[2],[4],[8],[],[5],[]],
[[6],[],[],[],[3],[],[],[],[8]],
[[],[],[8],[6],[9],[5],[1],[],[]]]).

exemplo_puzzle(7,[[[1],[9],[7],[4],[3],[8],[5],[2],[6]],
[[2],[6],[5],[7],[1],[9],[3],[8],[4]],
[[4],[8],[3],[6],[2],[5],[9],[1],[7]],
[[8],[2],[1],[5],[6],[7],[4],[3],[9]],
[[7],[3],[9],[8],[4],[1],[2],[6],[5]],
[[5],[4],[6],[2],[9],[3],[1],[7],[8]],
[[9],[5],[8],[3],[7],[2],[6],[4],[1]],
[[6],[1],[2],[9],[8],[4],[7],[5],[3]],
[[3],[7],[4],[1],[5],[6],[8],[9],[2]]]).

exemplo_puzzle(8,[[[],[9],[],[7],[],[],[8],[6],[]],
[[],[3],[1],[],[],[5],[],[2],[]],
[[8],[],[6],[],[],[],[],[],[]],
[[],[],[7],[],[5],[],[],[],[6]],
[[],[],[],[3],[],[7],[],[],[]],
[[5],[],[],[],[1],[],[7],[],[]],
[[],[],[],[],[],[],[1],[],[9]],
[[],[2],[],[6],[],[],[3],[5],[]],
[[],[5],[4],[],[],[8],[],[7],[]]]).

exemplo_puzzle(11,[[[],[9],[],[7],[],[],[8],[6],[]],
 [[],[3],[1],[],[],[5],[],[2],[]],
 [[8],[],[6],[],[],[],[],[],[]],
 [[],[],[7],[],[5],[],[],[],[6]],
 [[],[],[],[3],[],[7],[],[],[]],
 [[5],[],[],[],[1],[],[7],[],[]],
 [[],[],[],[],[],[],[1],[],[9]],
 [[],[2],[],[6],[],[],[3],[5],[]],
 [[],[5],[4],[],[],[8],[],[7],[]]]).

escreve_puzzle([]):-nl.
escreve_puzzle([Linha|Resto]):-writeln(Linha),escreve_puzzle(Resto).
