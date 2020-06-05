%---------------------------------
%---------------------------------
%Task 1:
%addition_circuit(N,Xs,Ys,Zs,Fs).
%addition_circuit(+,-,-,-,-).
%
%Input: N postive number 
%Output: addition-circuit Fs on input bit Xs=[X1,...,Xn]
%        and Ys=[Y1,.....,Yn] and output bits Zs=[Z1,.....,Zn,Zn+1].
%
%Exemple:
%?-addition_circuit(2, Xs, Ys, Zs, Fs).
%Xs = [X1,X2],
%Ys = [Y1,Y2],
%Zs = [Z1,Z2,Z3],
%Fs = [ full_adder(X1, Y1, 0, Z1, C2),
%       full_adder(X2, Y2, C2, Z2, Z3).
%     ]
%
%?-addition_circuit(3, Xs, Ys, Zs, Fs).
%Xs = [X1,X2,X3],
%Ys = [Y1,Y2,Y3],
%Zs = [Z1,Z2,Z3,Z4],
%Fs = [ full_adder(X1, Y1, 0, Z1, C2),
%       full_adder(X2, Y2, C2, Z2, C3),
%       full_adder(X3, Y3, C3, Z3, Z4).
%     ]
%
%?-addition_circuit(4, Xs, Ys, Zs, Fs).
%Xs = [X1,X2,X3,X4],
%Ys = [Y1,Y2,Y3.Y4],
%Zs = [Z1,Z2,Z3,Z4,Z5],
%Fs = [ full_adder(X1, Y1, 0, Z1, C2),
%       full_adder(X2, Y2, C2, Z2, C3),
%       full_adder(X3, Y3, C3, Z3, C4),
%       full_adder(X4, Y4, C4, Z4, Z5).
%     ]



%The idea of the recurssion the she build the lists at the back tracking,
%tail-recurssion.

%First send with carry 0
addition_circuit(N,Xs,Ys,Zs,Fs) :- addition_circuit(N,Xs,Ys,Zs,Fs,0).

%Base case when N=0
addition_circuit(0,[],[],[],[],_).

%base case when N=1 , I like to add to the Z list 2 elements,
%and the full adder will get the carry from C, and will not send the Z1
addition_circuit(1,[X|Xs],[Y|Ys],[Z,Z1|Zs],[F|Fs],C) :- 
                                                      F = full_adder(X,Y,C,Z,Z1),
                                                      addition_circuit(0,Xs,Ys,Zs,Fs,C).
%Case that N>1.
addition_circuit(N,[X|Xs],[Y|Ys],[Z|Zs],[F|Fs],C) :- N > 1,
                                                     F = full_adder(X,Y,C,Z,C1),
                                                     N1 is N-1,
                                                     addition_circuit(N1,Xs,Ys,Zs,Fs,C1).

%----------------------------------
%----------------------------------
%Task 2:
%eval_addition_circuit(Fs).
%eval_addition_circuit(+).
%
%Input:Fs - list of full-adder that given from Task1
%Output:evaluation of the the var from Task 1
%
%Exemple:
%?- addition_circuit(2, Xs, Ys, Zs, Fs),
%Xs = [1, 0], Ys = [1, 1],
%eval_addition_circuit(Fs).
%Xs = [1, 0],
%Ys = [1, 1],
%Zs = [0, 0, 1],
%Fs = [ full_adder(1, 1, 0, 0, 1),
%full_adder(0, 1, 1, 0, 1)
%]
%
%The Idea that every object in the list I call the full Adder implemention.
eval_addition_circuit([]).
eval_addition_circuit([full_adder(X,Y,Z,C,C1)|Fs]) :- full_adder(X,Y,Z,C,C1),
                                                   eval_addition_circuit(Fs). 

%Full Adder implemention
full_adder(0,0,0,0,0).
full_adder(0,1,0,1,0).
full_adder(1,0,0,1,0).
full_adder(1,1,0,0,1).
full_adder(0,0,1,1,0).
full_adder(0,1,1,0,1).
full_adder(1,0,1,0,1).
full_adder(1,1,1,1,1).

%----------------------------------
%----------------------------------
%Task 3:
%not_an_addition_circuit(Xs, Ys, Zs, Fs).
%
%Input:
%Output:
%
%Exemple:
%?- addition_circuit(2, Xs, Ys, Zs, Fs),
%not_an_addition_circuit(Xs, Ys, Zs, Fs).
%false.
%
%?- Xs = [X1, X2],
%Ys = [Y1, Y2],
%Zs = [Z1, Z2, Z3],
%Fs = [ full_adder(X1, Y1, 0, Z1, C2),
%full_adder(X2, Y2, 1, Z2, Z3), % error is here
%],
%not_an_addition_circuit(Xs, Ys, Zs, Fs).
%
%Xs = [0, 1],
%Ys = [1, 0],
%Zs = [1, 0, 1],
%Fs = [ full_adder(0, 1, 0, 1, 0),
%full_adder(1, 0, 1, 0, 1),
%],

%First we used the eval_addition_circuit on the Fs we get,
%than I build an addition_circuit, by used the addition_circuit from Task 1.
%Out of the assumption that the pradicate addition_circuit is working fine, 
%I get a good full adders in that same size.
%I used again the eval_addition_circuit on the new full_adder, and then compare the answers.
%If I dont get the same answer, the implemention is not goos and I return the implemention.
not_an_addition_circuit(Xs,Ys,Zs,Fs) :- length(Fs,L),
                                        eval_addition_circuit(Fs),
                                        addition_circuit(L,Xs,Ys,Zs1,Fs1),
										eval_addition_circuit(Fs1),
    									Zs1 \= Zs.
    
    
%----------------------------------
%----------------------------------
%Task 4:
%sorting_network(N,Comp,In,Out).
%sorting_network(+,-,-,-).
%
%Input: N number of "lines" at the Sorting sorting_network
%Output: Comps - sorting network, that representd a list of terms of 
%        the form comparator(A,B,C,D) as we leran at class.
%        In - representing the input values.
%        Out - representing the output valus.      
%
%Exemple:
%?- sorting_network(8, Cs, In, Out).
%Cs = [comparator(X1, X2, T1, T2), comparator(X3, X4, T3, T4),
%comparator(T1, T4, T5, T6), comparator(T2, T3, T7, T8),
%comparator(T5, T7, T9, T10), comparator(T6, T8, T11, T12),
%comparator(X5, X6, T13, T14), comparator(X7, X8, T15, T16),
%comparator(T13, T16, T17, T18), comparator(T14, T15, T19, T20),
%comparator(T17, T19, T21, T22), comparator(T18, T20, T23, T24),
%comparator(T9, T24, T25, T26), comparator(T10, T23, T27, T28),
%comparator(T11, T22, T29, T30), comparator(T12, T21, T31, T32),
%comparator(T25, T29, T33, T34), comparator(T27, T31, T35, T36),
%comparator(T33, T35, Y1, Y2), comparator(T34, T36, Y3, Y4),
%comparator(T26, T30, T37, T38), comparator(T28, T32, T39, T40),
%comparator(T37, T39, Y5, Y6), comparator(T38, T40, Y7, Y8)]
%In = [X1, X2, X3, X4, X5, X6, X7, X8]
%Out = [Y1, Y2, Y3, Y4, Y5, Y6, Y7, Y8]
%
%I implement the odd-even sorting. More explean on the PDF


sorting_network(N,Cs,In,Out) :- Iter is N/2,
                                sorting_network(N,Cs,In,Out,Iter).
    
sorting_network(0,[],In,Out,_) :- Out = In.
sorting_network(N,Cs,In,Out,Iter) :- N > 0,
                                        N1 is N-2,    
                                        sorting_network_odd(Iter,Cs1,In,Out1),
                                        IterOdd is Iter-1,
                                        append([],[Y|X],Out1),
                                        sorting_network_even(IterOdd,Cs2,X,Out2),
                                        append([Y],Out2,Out3),
                                        append(Cs1,Cs2,Cs3),
                                        append(Cs3,Cs4,Cs),
                                        sorting_network(N1,Cs4,Out3,Out,Iter).
sorting_network_odd(0,[],[],[]).
sorting_network_odd(N,[C|Cs],[I1,I2|In],[O1,O2|Out]) :- N > 0,
                                                        N1 is N-1,
                                                        C = comparator(I1,I2,O1,O2),
                                                        sorting_network_odd(N1,Cs,In,Out).

sorting_network_even(0,[],X,Y) :- Y = X.
sorting_network_even(N,[C|Cs],[I1,I2|In],[O1,O2|Out]) :- N > 0,
                                                        N1 is N-1,
                                                        C = comparator(I1,I2,O1,O2),
                                                        sorting_network_even(N1,Cs,In,Out).
%----------------------------------
%----------------------------------

%Task 5:
%measure_network(Cs,In,Out,Depth,Size)
%
%Input: Cs - network of comparators
%       In - input of not sorted list 
%       Out - Out put of sorted list
%
%Output: Depth - The maximum number of comparators along any path from an input to output
%        Size - The total number of comparators used
%
%Exemple: In the previews exemplae of task 4 the size is 24 and the depth is 6
%
%At the main pradicate I Call to 2 diffrent pradicate, one that measure the size of Cs (the list of the comparators)
%and the secend a pradicate that build a list of depth for every input in the In list. 
%then the Depth will be equal to the max in the list that the pradicate will build.



measure_network(Cs,In,_,Depth,Size) :- comparatorNum(Cs,0,Size),
    									 list_depth(In,D,Cs),
    									 max_list(D,Depth).
            
%The pradicate will count the number of comparators in the Cs list
comparatorNum([],X,Size) :- Size = X.
comparatorNum([_|Cn],X,Size) :- X1 is X+1,
                                comparatorNum(Cn,X1,Size).
								
%The pradicate list_depth will bilud a list of depth for every object in the In list.								
list_depth([],[],_).
list_depth([In|Ins],[D|Ds],Cs) :- depth_x(Cs,In,D),
    							  list_depth(Ins,Ds,Cs).

%The pradicate depth_x, will get a object from the In list and return the depth of the object
%in the Cs (list of comparators).

%The pradicate depth_x will check if that X, is the first or the secend element in the comparator,
%if its the case, the recurssion will call the pradicate with X=O1 and X=O2, and the depth will be the 
%max depth that the recurssion will return + 1.

%Base case when we at the end of the Cs list.
depth_x([],_,DepthX) :- DepthX = 0.

%Case that element that we looking for is in the first place the comparator input 
depth_x([comparator(I1,_,O1,O2)|Cs],X,DepthX):- I1 == X,
    										    depth_x(Cs,O1,DepthO1),
    										    depth_x(Cs,O2,DepthO2),
    											gt(DepthO1,DepthO2,DepthO),
    											DepthX is DepthO+1.

%Case that element that we looking for is in the secend place the comparator input 
depth_x([comparator(_,I2,O1,O2)|Cs],X,DepthX):- I2 == X,
    										 	depth_x(Cs,O1,DepthO1),
    										    depth_x(Cs,O2,DepthO2),
    											gt(DepthO1,DepthO2,DepthO),
    										    DepthX is DepthO+1.

%Case that element that we looking for isnt in the current comparator
depth_x([comparator(I1,I2,_,_)|Cs],X,DepthX):- I2 \== X,
    										   I1 \== X,
    										   depth_x(Cs,X,DepthX).

%pradicate that return in the the max value from X and Y
gt(X,Y,Z) :- Z is max(X,Y) .        

%----------------------------------
%----------------------------------
%Task 6:
%apply_network(Cs,In,Out).
%
%        In - list of number not sorted
%       Out - List of number sorted
%       Cs - list of comparator
%
%Exemple:
%   sorting_network(4,Cs,In,Out), In = [4,3,2,1], apply_network(Cs,In,Out).
%   Cs = [comparator(4, 3, 3, 4), comparator(2, 1, 1, 2),
%   comparator(4, 1, 1, 4), comparator(3, 1, 1, 3), comparator(4, 2, 2, 4), comparator(3, 2, 2, 3)],
%   In = [4, 3, 2, 1],
%   Out = [1, 2, 3, 4]
%   Cs = [comparator(2, 5, 2, 5), comparator(6, 3, 3, 6), comparator(4, 1, 1, 4),
% 
%   sorting_network(8,Cs,In,Out), In = [2,5,6,3,4,1,7,8], apply_network(Cs,In,Out).
%   comparator(7, 8, 7, 8), comparator(5, 3, 3, 5), comparator(6, 1, 1, 6),
%   comparator(4, 7, 4, 7), comparator(2, 3, 2, 3), comparator(5, 1, 1, 5),
%   comparator(6, 4, 4, 6), comparator(7, 8, 7, 8), comparator(3, 1, 1, 3),
%   comparator(5, 4, 4, 5), comparator(6, 7, 6, 7), comparator(2, 1, 1, 2),
%   comparator(3, 4, 3, 4), comparator(5, 6, 5, 6), comparator(7, 8, 7, 8),
%   comparator(2, 3, 2, 3), comparator(4, 5, 4, 5), comparator(6, 7, 6, 7),
%   comparator(1, 2, 1, 2), comparator(3, 4, 3, 4), comparator(5, 6, 5, 6),
%   comparator(7, 8, 7, 8), comparator(2, 3, 2, 3), comparator(4, 5, 4, 5), comparator(6, 7, 6, 7)],
%   In = [2, 5, 6, 3, 4, 1, 7, 8],
%   Out = [1, 2, 3, 4, 5, 6, 7, 8]

%The same idea of 'Task 3'.
apply_network([],_,_).
apply_network([comparator(I1,I2,O1,O2)|Cs],In,Out) :- comparator(I1,I2,O1,O2),
                                                      apply_network(Cs,In,Out).

%Comparatoe implemention
comparator(I1,I2,O1,O2) :- I1 =< I2,
                           O1 = I1,
                           O2 = I2.

comparator(I1,I2,O2,O1) :- I1 > I2,
                           O1 = I1,
                           O2 = I2.

%----------------------------------
%----------------------------------

%Task 7
%not_a_sorting_network(Cs,In,Out).
%
%	Cs - Comparator network 
%	In - List of vars (The input of the comparator)
%	Out - List of vars (The output of the comparator)
% 
%The pradicate will check if the Cs is a sorting network,
%if not, will return all the Input and output that the network not 
%sorted after unify.
%
%Exemple:
%?- In = [X1, X2, X3, X4],
%Out = [Y1, Y2, Y3, Y4],
%Cs = [ comparator(X1, X2, T1, T2),
%comparator(X3, X4, T3, T4),
%comparator(T1, T3, Y1, Y2),
%comparator(T2, T4, Y3, Y4)
%],
%not_a_sorting_network(Cs, In, Out).
%In = [1,1,0,0]
%Out = [0,1,0,1];
%...
%?- sorting_network(4, Cs, In, Out),
%not_a_sorting_network(Cs, In, Out).
%false.
%
%By use assign we put all the binary word at In.
%Then we use apply_network and check if the Out isnt sorted, by then Zero-one principle, 
%if the Out not sorted then its not a sorting network, and we return all the implemention that return not sorting output 

not_a_sorting_network(Cs,In,Out) :- assign(In),
    								apply_network(Cs,In,Out),
    								not_sorted(Out).

%The pradicate assign that we see in the class
assign([X|Xs]) :- member(X,[0,1]), assign(Xs).
assign([]).

%The pradicate not_sorted that we see in the class.
not_sorted(Ys) :-
        append(_,[X,Y|_],Ys), X>Y.

%----------------------------------
%----------------------------------
%Task 8:
%I use the URL that is in the PDF to get the false-table, and then by using DeMorgan I turn it to CNF
encode_full_adder(X,Y,Cin,Z,Cout,CNF) :- CNF = [[X,Y,-Cout],[X,Cin,-Cout],[Y,Cin,-Cout],[X,-Z,-Cout],[Y,-Z,-Cout],
                                                [Cin,-Z,-Cout],[-Cin,Z,Cout],[-Y,Z,Cout],[-Y,-Cin,Cout],[-X,Z,Cout],
                                                [-X,-Cin,Cout],[-X,-Y,Cout],[X,Y,Cin,-Z],[-X,-Y,-Cin,Z]].


%----------------------------------
%----------------------------------
%Task 9
%I used the same idea from 'Task 1' and build the CNF of the full_adder by using the pradicate from Task 8
encode_binary_addition(N, Xs, Ys, Zs, CNF) :- encode_binary_addition(N, Xs, Ys, Zs ,-1 ,CNF).                                                                                    

encode_binary_addition(0, [], [], [], _,[]).                                                                                 
encode_binary_addition(1,[X|Xn], [Y|Yn], [Z,Cout|Zn] , Cin, CNF) :- encode_full_adder(X,Y,Cin,Z,Cout,CNF1),
    																  encode_binary_addition(0,Xn,Yn,Zn,Cout,CNF2),
    																  append(CNF1,CNF2,CNF).


encode_binary_addition(N, [X|Xn], [Y|Yn], [Z|Zn] , Cin, CNF):- N > 1,
    										      			   N1 is N-1,
    										       			   encode_full_adder(X,Y,Cin,Z,Cout,CNF1),
    										                   encode_binary_addition(N1,Xn,Yn,Zn,Cout,CNF2),
    														   append(CNF1,CNF2,CNF).
    										  	

                                                                                    
