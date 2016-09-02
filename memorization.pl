:- dynamic(entry/5).
:- ensure_loaded(data).
%Get current date, get all records that are due, prompt key, take value. Determine if the value is incorrect and update 
dailyMemorization :-
       get_time(CurrentTime),
       findall(Key, (entry(Key,Value,N,EF,Date), CurrentTime > Date), Z),test(Z).

prompt(Q,_) :- read(Q).

test([H|T]) :- entry(H, Value, N, EF, Date),prompt(Q,Value), process(H,Q,[],T2), test(T,T2).
test([H|T], Retry) :- entry(H,Value,N,EF,Date),prompt(Q,Value), process(H,Q,Retry,T3), test(T, T3).
test([], Retry) :- retry(Retry).
test([]).

process(H,Q,[],[H]) :- Q<3,updateRecordFailure(H),!.
process(H,Q,T,T2) :- Q<3, updateRecordFailure(H),append(T,[H],T2),!.
process(H,Q,T,T2) :- Q==3, updateRecord(H,Q), append(T,[H],T2),!.
process(H,Q,T,T) :- Q>=4, updateRecord(H,Q),!.

validate(H,Q,[],[H]) :- Q<3,!.
validate(H,Q,T,T2) :- Q<4,append(T,[H],T2),!.
validate(H,Q,T,T) :- Q>=4,!.

retry([H|T]) :- entry(H,Value,N,EF,Date), write(H),nl, prompt(Q,Value), validate(H,Q,T,T2), retry(T2).
retry([]) :- write("That's all for now!").

updateRecord(Key,Q) :- entry(Key,Value,N,EF,Date), calculateInterval(N,EF,NewInterval), updateEF(EF,Q,NewEF), updatePractice(Date, NewInterval, NewDate), retract(entry(Key,Value,N,EF,Date)), assertz(entry(Key,Value,NewInterval,NewEF,NewDate)).
updateRecordFailure(Key) :- entry(Key, Value, N, EF, Date), updatePractice(Date, 1, NewDate), retract(entry(Key,Value,N,EF,Date)), assertz(entry(Key,Value,1,EF, NewDate)).

%calculateInterval(N, EF, Interval) -> N is the previous interval, is the number of days for the previous interval.
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
