%We import the libraries through this use_module predicate
:- use_module( [library(lists),
    io,
    fill]).

%defines the cross character
is_cross(x).

%defines the nought character
is_nought(o).

%defines empty character
is_empty(e).

%defines either cross or nough character
is_piece(Q) :- 
    Q = x.

is_piece(Q):-
    Q = o.

%other_player(?T,?P)
%Defining two Constants out of which one will be x and another one will be o, but not both of them will be same
other_player(T,P):-
    T = x,
    P = o.

other_player(T,P):-
    T = o,
    P = x.

%Learnt about the board representations from here
%https://swish.swi-prolog.org/p/Tic-Tac-Toe.swinb

%row(?RowNumber, ?Board, row(?RowNumber, ?A,?B,?C))
%Defining row where the first argument is the row number, the second one is the board that will 
%pass and the third one defines the elements of that specific row
row(1, Board, row(1,A,B,C)):- Board = [A,B,C,_,_,_,_,_,_].
row(2, Board, row(2,A,B,C)):- Board = [_,_,_,A,B,C,_,_,_].
row(3, Board, row(3,A,B,C)):- Board = [_,_,_,_,_,_,A,B,C].

%column(?ColumnNumber, ?Board, col(?ColumnNumber, ?A, ?B, ?C))
%Defining column where the first argument is the column number, the second one is the board that
% will pass and the thirds one defines the elements of that specific column
column(1, Board, col(1,A,B,C)):- Board = [A,_,_,B,_,_,C,_,_].
column(2, Board, col(2,A,B,C)):- Board = [_,A,_,_,B,_,_,C,_].
column(3, Board, col(3,A,B,C)):- Board = [_,_,A,_,_,B,_,_,C].

%diagonal(?TopBottom, ?Board, dia(?TopBottom, ?A, ?B, ?C))
%Defines the diagonals on which the first argument is wither top_to_bottom or bottom_to_top, second 
%argument defines the board that will pass and thrid one defines the elements of the diagonal either from top to bottom or bottom to top
diagonal(top_to_bottom, Board, dia(top_to_bottom,A,B,C)):- Board = [_,_,A,_,B,_,C,_,_].
diagonal(bottom_to_top, Board, dia(bottom_to_top,A,B,C)):- Board = [A,_,_,_,B,_,_,_,C].

%square(?RowNumber, ?ColumnNumber, ?Board, squ(?RowNumber, ?ColumnNumber, ?Player))
%Defines a specific square on a specific row and column
square(RowNumber, ColumnNumber, Board, squ( RowNumber, ColumnNumber, Player )):-
    assignValue(RowNumber, ColumnNumber, Board, Player).

%The board defines on a specific row and column which part of the board will the square be   
assignValue(1, 1, Board, Player) :- Board = [Player,_,_,_,_,_,_,_,_].
assignValue(2, 1, Board, Player) :- Board = [_,Player,_,_,_,_,_,_,_].
assignValue(3, 1, Board, Player) :- Board = [_,_,Player,_,_,_,_,_,_].
assignValue(1, 2, Board, Player) :- Board = [_,_,_,Player,_,_,_,_,_].
assignValue(2, 2, Board, Player) :- Board = [_,_,_,_,Player,_,_,_,_].
assignValue(3, 2, Board, Player) :- Board = [_,_,_,_,_,Player,_,_,_].
assignValue(1, 3, Board, Player) :- Board = [_,_,_,_,_,_,Player,_,_].
assignValue(2, 3, Board, Player) :- Board = [_,_,_,_,_,_,_,Player,_].
assignValue(3, 3, Board, Player) :- Board = [_,_,_,_,_,_,_,_,Player].

%The first two arguments are the row number and column number and the third argument defines for that specific square from the row and column numbers
empty_square(1, 1, [e,_,_,_,_,_,_,_,_]).
empty_square(2, 1, [_,e,_,_,_,_,_,_,_]).
empty_square(3, 1, [_,_,e,_,_,_,_,_,_]).
empty_square(1, 2, [_,_,_,e,_,_,_,_,_]).
empty_square(2, 2, [_,_,_,_,e,_,_,_,_]).
empty_square(3, 2, [_,_,_,_,_,e,_,_,_]).
empty_square(1, 3, [_,_,_,_,_,_,e,_,_]).
empty_square(2, 3, [_,_,_,_,_,_,_,e,_]).
empty_square(3, 3, [_,_,_,_,_,_,_,_,e]).

%a representation of the initial board
initial_board([e,e,e,e,e,e,e,e,e]).

%a representation of the empty board
empty_board(Board) :-
    Board = [_,_,_,_,_,_,_,_,_].

%and_the_winner_is(?Board, ?Player)
%Defines if three squares are in a single row, thus a winning condition
%The Board argument passes the existing board and the Player passes if its a cross or a nought
and_the_winner_is(Board, Player):- 
    row(RowNumber, Board, row(RowNumber,Player,Player,Player)).

%and_the_winner_is(?Board, ?Player)
%Defines if three squares are in a single column, thus a winning condition
%The Board argument passes the existing board and the Player passes if its a cross or a nought
and_the_winner_is(Board, Player):- 
    column(ColumnNumber, Board, col(ColumnNumber,Player,Player,Player)).

%and_the_winner_is(?Board, ?Player)
%%Defines if three squares are in a single diagonal, thus a winning condition
%The Board argument passes the existing board and the Player passes if its a cross or a nought
and_the_winner_is(Board, Player):- 
    diagonal(TopBottom, Board, dia(TopBottom,Player,Player,Player)).

%Calling playHH will basically start the game for Human vs Human game. It will first display the board and lastly call playHH(?Cross, ?Board) which
% is recursive. Here Cross implies the x square and Board represent the initial board
playHH :- welcome,
	initial_board( Board ),
	display_board( Board ),
	is_cross( Cross ),
    playHH(Cross, Board).

%If there is a winning condition for any square then this will be called
%playHH(+_, ?Board)
%Here we dont care about if a nought or a cross has been passed. If there is a winning condition it will report the winner
playHH(_, Board):- 
    is_piece(Q),
    and_the_winner_is(Board, Q),
    report_winner(Q).

%If the board is full and it does not contain and more square then it will report a stalemate
playHH(_, Board):-
    no_more_free_squares(Board),
    report_stalemate.

%Firstly it will take a legal move from either of the square and the fill it on the board and then display on the board
%As it is a recursive call it will then do the same thing for the other square
playHH(Player, Board):-
    get_legal_move(Player, X, Y, Board),
    fill_square(X, Y, Player, Board, NewBoard),
    other_player(Player, Player2),
    display_board(NewBoard),
    playHH(Player2, NewBoard).

%e is our empty square. So, if there is no more e in the board means the board is full and there is no empty space
no_more_free_squares(Board):-
    not(member(e, Board)).

%Calling playHC will start a Human vs Computer game. Fisrt it will display a welcome message followed by displaying the initial board. Afterwrads 
%it will start playing with the cross character. 
playHC :- welcome,
    initial_board(Board),
    display_board(Board),
    is_cross( Cross ),
    playHC(Cross, Board).

%Here whatever the square is, on the existing board which is passed here as Board, for noughts or crosses if there is 
%already a winning combination, then it will call this
playHC(_, Board):-
    is_piece(Q),
    and_the_winner_is(Board, Q),
    report_winner(Q).

%If the board is full and it does not contain and more square then it will report a stalemate
playHC(_, Board):-
    no_more_free_squares(Board),
    report_stalemate.

%We have set the human player will start with a cross. So here get_legal_move will take the human's move and fill it on the board through fill_square.
%Afterwards it will display using display_board. Then it will switch players and call the playHC for noughts.
playHC(x, Board):-
    get_legal_move(x, X, Y, Board),
    fill_square(X, Y, x, Board, NewBoard),
    display_board(NewBoard),
    other_player(x, o),
    playHC(o, NewBoard).

%After playHC(x, Board), this will be called where choose_move will choose a move for the board and then it will fill the square using fill_square. 
%Afterwads it will display the board and then pass it to the cross player.
playHC(o, Board):- 
    choose_move(o, X, Y, Board),
    report_move( o, X, Y ),
    fill_square( X, Y, o, Board, NewBoard ),
    display_board(NewBoard),
    playHC(x, NewBoard).

%If there exist a winning possibility for o then it will go for it. Here the board illustrtaes all the winning possibilities for o.
choose_move(o, 1, 1, Board):- Board = [e,o,o,_,_,_,_,_,_].
choose_move(o, 1, 1, Board):- Board = [e,_,_,o,_,_,o,_,_].
choose_move(o, 1, 1, Board):- Board = [e,_,_,_,o,_,_,_,o].
choose_move(o, 2, 1, Board):- Board = [o,e,o,_,_,_,_,_,_].
choose_move(o, 2, 1, Board):- Board = [_,e,_,_,o,_,_,o,_].
choose_move(o, 3, 1, Board):- Board = [o,o,e,_,_,_,_,_,_].
choose_move(o, 3, 1, Board):- Board = [_,_,e,_,_,o,_,_,o].
choose_move(o, 3, 1, Board):- Board = [_,_,e,_,o,_,o,_,_].
choose_move(o, 1, 2, Board):- Board = [_,_,_,e,o,o,_,_,_].
choose_move(o, 1, 2, Board):- Board = [o,_,_,e,_,_,o,_,_].
choose_move(o, 2, 2, Board):- Board = [_,_,_,o,e,o,_,_,_].
choose_move(o, 2, 2, Board):- Board = [_,o,_,_,e,_,_,o,_].
choose_move(o, 2, 2, Board):- Board = [o,_,_,_,e,_,_,_,o].
choose_move(o, 2, 2, Board):- Board = [_,_,o,_,e,_,o,_,_].
choose_move(o, 3, 2, Board):- Board = [_,_,_,o,o,e,_,_,_].
choose_move(o, 3, 2, Board):- Board = [_,_,o,_,_,e,_,_,o].
choose_move(o, 1, 3, Board):- Board = [o,_,_,o,_,_,e,_,_].
choose_move(o, 1, 3, Board):- Board = [_,_,o,_,o,_,e,_,_].
choose_move(o, 1, 3, Board):- Board = [_,_,_,_,_,_,e,o,o].
choose_move(o, 2, 3, Board):- Board = [_,_,_,_,_,_,o,e,o].
choose_move(o, 2, 3, Board):- Board = [_,o,_,_,o,_,_,e,_].
choose_move(o, 3, 3, Board):- Board = [_,_,o,_,_,o,_,_,e].
choose_move(o, 3, 3, Board):- Board = [_,_,_,_,_,_,o,o,e].
choose_move(o, 3, 3, Board):- Board = [o,_,_,_,o,_,_,_,e].

%If there exist a winning possibilities for x ,then o will block it. Here the board illiustrates all the winning possibilities for x.
choose_move(o, 1, 1, Board):- Board = [e,x,x,_,_,_,_,_,_].
choose_move(o, 1, 1, Board):- Board = [e,_,_,x,_,_,x,_,_].
choose_move(o, 1, 1, Board):- Board = [e,_,_,_,x,_,_,_,x].
choose_move(o, 2, 1, Board):- Board = [x,e,x,_,_,_,_,_,_].
choose_move(o, 2, 1, Board):- Board = [_,e,_,_,x,_,_,x,_].
choose_move(o, 3, 1, Board):- Board = [x,x,e,_,_,_,_,_,_].
choose_move(o, 3, 1, Board):- Board = [_,_,e,_,_,x,_,_,x].
choose_move(o, 3, 1, Board):- Board = [_,_,e,_,x,_,x,_,_].
choose_move(o, 1, 2, Board):- Board = [_,_,_,e,x,x,_,_,_].
choose_move(o, 1, 2, Board):- Board = [x,_,_,e,_,_,x,_,_].
choose_move(o, 2, 2, Board):- Board = [_,_,_,x,e,x,_,_,_].
choose_move(o, 2, 2, Board):- Board = [_,x,_,_,e,_,_,x,_].
choose_move(o, 2, 2, Board):- Board = [x,_,_,_,e,_,_,_,x].
choose_move(o, 2, 2, Board):- Board = [_,_,x,_,e,_,x,_,_].
choose_move(o, 3, 2, Board):- Board = [_,_,_,x,x,e,_,_,_].
choose_move(o, 3, 2, Board):- Board = [_,_,x,_,_,e,_,_,x].
choose_move(o, 1, 3, Board):- Board = [x,_,_,x,_,_,e,_,_].
choose_move(o, 1, 3, Board):- Board = [_,_,x,_,x,_,e,_,_].
choose_move(o, 1, 3, Board):- Board = [_,_,_,_,_,_,e,x,x].
choose_move(o, 2, 3, Board):- Board = [_,_,_,_,_,_,x,e,x].
choose_move(o, 2, 3, Board):- Board = [_,x,_,_,x,_,_,e,_].
choose_move(o, 3, 3, Board):- Board = [_,_,x,_,_,x,_,_,e].
choose_move(o, 3, 3, Board):- Board = [_,_,_,_,_,_,x,x,e].
choose_move(o, 3, 3, Board):- Board = [x,_,_,_,x,_,_,_,e].



%Choose the middle square if available
choose_move(o, 2, 2, Board):-
    Board = [_,_,_,_,e,_,_,_,_].

%choose the corner squares if available
choose_move(o, 1, 1, Board):- 
    Board = [e,_,_,_,_,_,_,_,_].
choose_move(o, 3, 1, Board):- 
    Board = [_,_,e,_,_,_,_,_,_].
choose_move(o, 1, 3, Board):- 
    Board = [_,_,_,_,_,_,e,_,_].
choose_move(o, 3, 3, Board):- 
    Board = [_,_,_,_,_,_,_,_,e].

%dumbly choose a square
choose_move(o, X, Y, Board) :- 
    empty_square(X, Y, Board).

%First it will display a welcome message and display the initial board. It will start with a cross character and then start playing.
playSS :- welcome,
    initial_board(Board),
    display_board(Board),
    is_cross( Cross ),
    playSS(Cross, Board).

%If there is a winning condition for any square then this will be called
%playSS(+_, ?Board)
%Here we dont care about a nought or a cross has been passed. If there is a winning condition it will report the winner immediately
playSS(_, Board):-
    is_piece(Q),
    and_the_winner_is(Board, Q),
    report_winner(Q).

%We have set the human player will start with a cross. So here get_legal_move will take the human's move and fill it on the board through fill_square.
%Afterwards it will display using display_board. Then it will switch players and call the playSS(o, NewBoard) for noughts.
playSS(x, Board):-
    get_legal_move(x, X, Y, Board),
    fill_square(X, Y, x, Board, NewBoard),
    display_board(NewBoard),
    other_player(x, o),
    playSS(o, NewBoard).

%After playSS(x, Board), this will be called where choose_move will choose a move for the board and then it will fill the square using fill_square. 
%Afterwads it will display the board and then pass it to the cross player.
playSS(o, Board):- 
    choose_move(o, X, Y, Board),
    report_move( o, X, Y ),
    fill_square( X, Y, o, Board, NewBoard ),
    display_board(NewBoard),
    playSS(x, NewBoard).

%playSS(?Player, ?Board)
%Player will pass if it is a nought player or a cross player. Afterwards it will check if there is any winning possiblity 
%If there is a winning possibility then the game will go on or else it will report a stalemate
playSS(Player, Board):-
    is_piece(Player),
    not(possible_win(Player, Board)),
    report_stalemate.

%possible_win(?Player,?Board)
%In this predicate we check for applying the next square for any player(move(Board, Player, NewBoard)), if there exist a winner. Afterwards we 
%switch the players and check if there is a winning possibility for the other player. possible_win is recursive.
possible_win(Player, Board):-
    move(Board, Player, NewBoard),
    and_the_winner_is(NewBoard, Player),
    other_player(Player,Player2),
    possible_win(Player2, Board).

%In the move predicates the first argument is the existing board, the second argument is the player(cross or noughts), the third argument is the new board
%It checks on the existing board, for any move if there is a winning chance
move([e,B,C,D,E,F,G,H,I], Player, [Player,B,C,D,E,F,G,H,I]).
move([A,e,C,D,E,F,G,H,I], Player, [A,Player,C,D,E,F,G,H,I]).
move([A,B,e,D,E,F,G,H,I], Player, [A,B,Player,D,E,F,G,H,I]).
move([A,B,C,e,E,F,G,H,I], Player, [A,B,C,Player,E,F,G,H,I]).
move([A,B,C,D,e,F,G,H,I], Player, [A,B,C,D,Player,F,G,H,I]).
move([A,B,C,D,E,e,G,H,I], Player, [A,B,C,D,E,Player,G,H,I]).
move([A,B,C,D,E,F,e,H,I], Player, [A,B,C,D,E,F,Player,H,I]).
move([A,B,C,D,E,F,G,e,I], Player, [A,B,C,D,E,F,G,Player,I]).
move([A,B,C,D,E,F,G,H,e], Player, [A,B,C,D,E,F,G,H,Player]).    



    
%Mishkat Haider Chowdhury
%ID:0594966
    

    



