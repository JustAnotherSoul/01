:- ensure_loaded("../data/entries").
	   
%store(Filename) -> store the 'entry', the user data in the data file.
store(Filename) :- 
	tell(Filename), listing(entry/5), told.

%Process the record, updating it appropriately. Puts the element back in the list if it was a failure.
process(H,Q,[],[H]) :- Q<3,updateRecordFailure(H).
process(H,Q,T,T2) :- Q<3, updateRecordFailure(H),append(T,[H],T2).
process(H,Q,T,T2) :- Q==3, updateRecord(H,Q), append(T,[H],T2).
process(H,Q,T,T) :- Q>=4, updateRecord(H,Q).

%Updates the specified key based on the Q value given (Q >= 3).
updateRecord(Key,Q) :- entry(Key,Value,N,EF,Date), calculateInterval(N,EF,NewInterval), updateEF(EF,Q,NewEF), get_time(CurrentDate), updatePractice(CurrentDate, NewInterval, NewDate), retract(entry(Key,Value,N,EF,Date)), assertz(entry(Key,Value,NewInterval,NewEF,NewDate)).
%Updates the specified key based on the Q Value given (Q < 3)
updateRecordFailure(Key) :- entry(Key, Value, N, EF, Date), get_time(CurrentDate), updatePractice(CurrentDate, 1, NewDate), retract(entry(Key,Value,N,EF,Date)), assertz(entry(Key,Value,1,EF, NewDate)).

%calculateInterval(N, EF, Interval) -> N is the previous interval, is the number of days for the previous interval.
calculateInterval(0, _EF, Interval) :-
	Interval is 1.
calculateInterval(1, _EF, Interval) :-
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
