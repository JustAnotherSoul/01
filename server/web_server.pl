:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_error)).
:- use_module(library(http/html_write)).
:- use_module(library(http/http_parameters)).
:- ensure_loaded("../algorithm/memorization").
:- ensure_loaded("../data/entries").
:- ensure_loaded("../data/data").
:- ensure_loaded("web_utils").
server(Port) :-
	http_server(http_dispatch, [port(Port)]).

:- http_handler(/, welcome, [prefix]).
:- http_handler('/memorize.html', begin_memorization, []).
:- http_handler('/response.html', respond, []). 
:- http_handler('/update.html', update,[]).

%Set the title to 'Welcome' and call the predicate "welcome_page" with the request, the welcome page redirects to the memorization page.
welcome(Request) :-
	reply_html_page(
		title('Welcome!'),[\welcome_page(Request)]).
	
%Puts the keys of entries due for today into 'KeySet'
get_practice_set(KeySet) :-
	get_time(CurrentTime),
	findall(Key, (entry(Key,_Value,_N,_EF,Date), CurrentTime > Date), 		KeySet).

%Landing point for 'memorize.html'. Gets the current time, finds all entries that are due and prompts for them. Stores the result in 'entries2.pl' User logins: instead of 'entries2' 'entries_UID/USER_NAME/etc' 
begin_memorization(_Request) :-
        get_practice_set(Z),	
	create_ui(Z).

%Landing point for 'update.html'. Updates the entry based on the users response. First pulls out the headers, then it converts the remaining practice back to a list of numbers (likewise the key), and calls the 'process' method.
update(Request) :- 
	http_parameters(Request, [key(Key,[]), rating(Rating,[]), practice_remaining(Practice,[])]),
	atom_number(Key, H),
	atom_number(Rating, Q),
	get_list(Practice, RemainingList),
	process(H,Q,RemainingList, NewPractice),
       	store('entries2.pl'),
	create_ui(NewPractice).	
	
%Landing point for 'response.html'
respond(Request) :-
	http_parameters(Request, [key(Key,[]),answer(Answer,[]),practice_remaining(Practice,[])]), 
	reply_html_page(
		title('Rate your response'),
		[\response_form(_Request, Key, Practice, Answer)]).

%Prepare and prompt the form for the specified verses (this will be done several times)
create_ui(Z) :-
	reply_html_page(
		title('Huzzah!'),
		[\prompt_form(_Request, Z)]).

practice_end -->
	html_begin(h1),
	['Well done!'],
	html_end(h1),
	html_begin(br),
	['You have completed all outstanding practice for the day!'].

welcome_page(_Request) -->
		html_begin(p),
		['Hello and welcome! Click '],
		html_begin(a(href('memorize.html'))),
		['here'],
		html_end(a),
		[' to be taken to the memorization portion of the site'],
		html_end(p).

%This will be called once for each entry to be done eventually:
%This is passing in a hidden input the key of the item being tested (to get it out on the other side), as well as (soon) the rest of the list.
prompt_form(_Request, [H|T]) -->
	{
		entry(H, Value, _N, _EF, _Date),
		data(Value, Hint, _Answer)
	},
	{
		get_string(T, TailString)
	},
	html_begin(form(action('response.html'))),
	['Hint: ',Hint, '<br/>','Your Answer: '],
	html_begin(input(type(text), name(answer), autocomplete(off))),
	html_begin(input(type(hidden), name(key), value(H))),
	html_begin(input(type(hidden), name(practice_remaining), value(TailString))),
	html_begin(input(type(submit), value('Submit'))).
prompt_form(_Request, [H]) --> 
	{
		entry(H, Value, _N, _EF, _Date),
		data(Value, Hint, _Answer)
	},
	html_begin(form(action('response.html'))),
	['Hint: ', Hint, '<br/>', 'Your Answer: '],
	html_begin(input(type(text), name(answer), autocomplete(off))),
	html_begin(input(type(hidden), name(key), value(H))),
	html_begin(input(type(hidden), name(practice_remaining), value("-1"))),
	html_begin(input(type(submit), value('Submit'))).
prompt_form(_Request, []) -->
	practice_end.

%This takes a list and returns it in a string
get_string([H|T], TailString) :-
	get_string(T, TailString2),
	string_concat(",", TailString2, TailString3),
	string_concat(H, TailString3, TailString).
get_string([H], H).

%Gets a number list from the string
get_list('-1', []).
get_list(String, List) :-
	split_string(String, ",", "", AsList),
	to_number_list(AsList, List).

%Converts a list of strings to a list of numbers
to_number_list([H|T], NumberList) :-
	atom_string(Atom, H), 
	atom_number(Atom, Num),
	to_number_list(T, NumberList2),
	append([Num],NumberList2, NumberList).
to_number_list([], []).

%This response form provides the feed back (1-5 score of how easily it was remembered), and then the memorization algorithm will be called through once this is submitted. (Memorization: process(H,Q,T,NewT))
response_form(_Request, Key, KeyList, Answer) -->
	{
		atom_number(Key, H),
		entry(H, Value, _N, _EF, _Date),
		data(Value, _Hint, Actual)
	},
	html_begin(form(action('update.html'))),
	['Your response was: ', Answer, '<br>The actual answer was: ', Actual, '<br>'],
	radio_button(rating, 1),
	radio_button(rating, 2),
	checked_radio_button(rating, 3),
	radio_button(rating, 4),
	radio_button(rating, 5),
	%	html_begin(input(type(text), name(rating), autocomplete=off)),
	html_begin(input(type(hidden), name(key), value(Key))),
	html_begin(input(type(hidden), name(practice_remaining), value(KeyList))),
	html_begin(input(type(submit), value('Submit'))).
	
