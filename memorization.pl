:- ensure_loaded(data).
:- ensure_loaded(entries).
	   
store(Filename) :- 
	tell(Filename), listing(entry/5), told.

prompt(Q,Value) :- data(Value, Hint, Answer), write(Value), nl, write("Enter the answer, or H for hint"), nl, read_string(user_input, "\n", "\r", End, String), userResponse(Q, String, Value).
prompt(Q,Value) :- \+data(Value, _, _), write("A data error occurred could not find an entry labeled: "), write(Value), nl, Q is 4.

userResponse(Q, "H", Value) :- data(Value, Hint, Answer), write(Hint), nl, prompt(Q,Value).
userResponse(Q, Str, Value) :- data(Value, Hint, Answer), write("Your response: "), write(Str), nl, write("The answer is: "), write(Answer), nl, getScoring(Q).

getScoring(Q) :- write("Score yourself 0-5, 0 being couldn't remember at all, 3 remembered but with great difficulty, and 5 being remembered perfectly"), nl, read_string(user_input, "\n", "\r", End, Str), atom_string(Temp, Str), checkIfNum(Temp, Q).

checkIfNum(Temp, Q) :- atom_number(Temp, Q).
checkIfNum(Temp, Q) :- \+ atom_number(Temp, Q), write("Sorry, invalid input: "), nl, getScoring(Q).

test([H|T]) :- entry(H, Value, N, EF, Date),prompt(Q,Value), process(H,Q,[],T2), test(T,T2), !.
test([]) :- write("You've already done all necessary practice for today"), !.
test([H|T], Retry) :- entry(H,Value,N,EF,Date),prompt(Q,Value), process(H,Q,Retry,T3), test(T, T3), !.
test([], Retry) :- retry(Retry), !.

process(H,Q,[],[H]) :- Q<3,updateRecordFailure(H).
process(H,Q,T,T2) :- Q<3, updateRecordFailure(H),append(T,[H],T2).
process(H,Q,T,T2) :- Q==3, updateRecord(H,Q), append(T,[H],T2).
process(H,Q,T,T) :- Q>=4, updateRecord(H,Q).

validate(H,Q,[],[H]) :- Q<4.
validate(H,Q,T,T2) :- Q<4,append(T,[H],T2).
validate(H,Q,T,T) :- Q>=4.

retry([H|T]) :- entry(H,Value,N,EF,Date), prompt(Q,Value), validate(H,Q,T,T2), retry(T2).
retry([]) :- write("That's all for now!").

updateRecord(Key,Q) :- entry(Key,Value,N,EF,Date), calculateInterval(N,EF,NewInterval), updateEF(EF,Q,NewEF), get_time(CurrentDate), updatePractice(CurrentDate, NewInterval, NewDate), retract(entry(Key,Value,N,EF,Date)), assertz(entry(Key,Value,NewInterval,NewEF,NewDate)).
updateRecordFailure(Key) :- entry(Key, Value, N, EF, Date), get_time(CurrentDate), updatePractice(CurrentDate, 1, NewDate), retract(entry(Key,Value,N,EF,Date)), assertz(entry(Key,Value,1,EF, NewDate)).

%calculateInterval(N, EF, Interval) -> N is the previous interval, is the number of days for the previous interval.
calculateInterval(0, EF, Interval) :-
	Interval is 1.
calculateInterval(1, EF, Interval) :-
	Interval is 6.
calculateInterval(N, EF, Interval) :-
	Interval is N*EF.

%updateEF(EF1,Q, EF2) -> EF1 is the current EF, EF2 is the new EF, Q is the rating supplied by the user, the new EF cannot be below 1.3 or above 2.5.
updateEF(EF1, Q, EF2) :- 
	EF is EF1-0.8+0.28*Q-0.02*Q*Q, boundCheck(EF, EF2).

%Boundcheck(EF, EF2) -> EF2 is EF modified to be in the range 1.3 to 2.5.
boundCheck(EF, EF2) :- EF>2.5, EF2 is 2.5.
boundCheck(EF, EF2) :- EF<1.3, EF2 is 1.3.
boundCheck(EF, EF2) :- EF2 is EF.

%updatePractice(CurrentDate, Interval, NewDate) -> Take the CurrentDate add the Interval for NewDate in seconds 
updatePractice(CurrentDate, Interval, NewDate) :- TempDate is CurrentDate+Interval*86400, stamp_date_time(TempDate, date(Y,M,D,_,_,_,_,_,_), local), date_time_stamp(date(Y,M,D,0,0,0,_,_,_), NewDate).
