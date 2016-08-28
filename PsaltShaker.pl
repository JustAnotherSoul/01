menu :- 
	write('Select an option below.'), nl,
	write('(1) Attempt a psalm'), nl,
	write('(2) Highscores'), nl,
	write('(q) Quit'), nl,
	read_string(user_input, "\n", "\r", End, X), menu_option(X).

menu_option("1") :-
	write('Construction!'), nl, menu, !.	
menu_option("2") :- 
	write('More construction!'), nl, menu, !.
menu_option("q") :- 
	write('Good bye!'), !.
menu_option(X) :-
	write(X), write( " is unrecognized."), nl, menu, !.