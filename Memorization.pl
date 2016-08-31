% SM-2 Algorithm (SuperMemo v2)
% I(1) = 1
% I(2) = 6
% I(n) = I(n-1)*EF
% EF' = EF - 0.8 + 0.28*q - 0.02 * q * q
% Where q = 0 -> Incorrect response, No memory
% 	q = 1 -> Incorrect response, Remembered
% 	q = 2 -> Incorrect response, Correct response seemed easy to remember
% 	q = 3 -> Correct, recalled with serious difficulty
% 	q = 4 -> Correct, recalled with hesitation
% 	q = 5 -> Perfect response
% If q < 3 reset I(n) to n = 1, and leave EF alone.
%
% Repeat any item where q  <  4 until q  =  4
%
% Snippet of code to get DAY, MONTH, YEAR out of timestamp:
% get_time(X), stamp_date_time(X, date(A,B,C, _,_,_,_,_,_), local).
% A is Year
% B is Month
% C is Day
%
% Need some means to add days and such to this. Could just add 24 hours worth of seconds to time.
% Yup: D,E,F contain the year, month, and day respectively that we want, piping that back in results in X3 binding to the timestamp in seconds we want.
% get_time(X), X2 is X+(2*86400), stamp_date_time(X, date(A,B,C, _,_,_,_,_,_), local), stamp_date_time(X2, date(D,E,F, _,_,_,_,_,_), local),
% date_time_stamp(date(D,E,F,0,0,0,_,_,_), X3)
%
% Record format: Key, Value, I(n), EF, Date 
% 
%calculateInterval(N, EF, Interval) -> N is the previous interval, is the number of days for the previous interval.
:-dynamic(entry/5).
calculateInterval(0, EF, Interval) :-
	Interval is 1, !.
calculateInterval(1, EF, Interval) :-
	Interval is 6, !.
calculateInterval(N, EF, Interval) :-
	Interval is N*EF, !.

%updateEF(EF1,Q, EF2) -> EF1 is the current EF, EF2 is the new EF, Q is the rating supplied by the user, the new EF cannot be below 1.3 or above 2.5.
updateEF(EF1, Q, EF2) :- 
	EF is EF1-0.8+0.28*Q-0.02*Q*Q, boundCheck(EF, EF2).

%Boundcheck(EF, EF2) -> EF2 is EF modified to be in the range 1.3 to 2.5.
boundCheck(EF, EF2) :- EF>2.5, EF2 is 2.5, !.
boundCheck(EF, EF2) :- EF<1.3, EF2 is 1.3, !.
boundCheck(EF, EF2) :- EF2 is EF, !.

%updatePractice(CurrentDate, Interval, NewDate) -> Take the CurrentDate add the Interval for NewDate in seconds 
updatePractice(CurrentDate, Interval, NewDate) :- TempDate is CurrentDate+Interval*86400, stamp_date_time(TempDate, date(Y,M,D,_,_,_,_,_,_), local), date_time_stamp(date(Y,M,D,0,0,0,_,_,_), NewDate).
% Awesome, so the algorithm is done, along with relevant helper methods. Now we just need a little more: Stuff to use this, and a user interface.

%Maybe start from UI down?
entry("Foo", "Bar", 0, 2.5, 1472587304.0).

%Get current date, get all records that are due, prompt key, take value. Determine if the value is incorrect and 
dailyMemorization :-
       get_time(CurrentTime),
       findall(Key, (entry(Key,Value,N,EF,Date), CurrentTime > Date), Z),test(Z).

test([H|T]) :- entry(H, Value, N, EF, Date), write(H), nl, write(Value), nl, write(N),nl, write(EF), nl,read(Q), process(H,Q,T,T2), test(T2).
test([]) :- write("All done!").

process(H,Q,[],[H]) :- Q<3,updateRecordFailure(H), !.
process(H,Q,T,T2) :- Q<3, updateRecordFailure(H),append(T,H,T2),!.
process(H,Q,T,T) :- Q>=3, updateRecord(H), !.

updateRecord(H) :- entry(H,Value,N,EF,Date), calculateInterval(N,EF,NewInterval), updateEF(EF,Q,NewEF), updatePractice(Date, NewInterval, NewDate), retract(entry(H,Value,N,EF,Date)), assertz(entry(H,Value,NewINterval,NewEF,NewDate)).
%This works below because we retry until success.
updateRecordFailure(H) :- entry(H, Value, N, EF, Date), newInterval is 0, retract(entry(H,Value,N,EF,Date)), assertz(entry(H,Value,NewInterval,EF, Date)).

	
