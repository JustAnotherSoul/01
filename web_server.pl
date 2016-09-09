:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_error)).
:- use_module(library(http/html_write)).
:- use_module(library(http/http_parameters)).
:- ensure_loaded(memorization).
:- ensure_loaded(entries).
server(Port) :-
	http_server(http_dispatch, [port(Port)]).

:- http_handler(/, begin_memorization, []).

begin_memorization(_Request) :- 
	get_time(CurrentTime),
	findall(Key, (entry(Key,Value,N,EF,Date), CurrentTime > Date), Z), goFor(Z).

goFor(Z) :-
	reply_html_page(
		title('Huzzah!'),
		[\construct_user_interface(Request, Z)]).

construct_user_interface(Request, Z) -->
	html(
		[
		h1('Got the following list:')
		]
	),
	html_begin(table(border(1), align(center), width('80%'))),
	html([\table_header('Index'), \table_header('Value'),\table_header('Hint'),\table_header('Answer'), \table_header('Interval'), \table_header('Effort Factor'), \table_header('Date')]),

	html([\table_data(Z)]),
	html_end(table).

table_header(X) -->
	html_begin(th),
	html([
		\[X]
	]),
	html_end(th).

table_data([H|T]) -->
	{ 
		entry(H, Value, N, EF, Date),
		data(Value, Hint, Answer)
	},
	html_begin(tr),
	table_column(H),
	table_column(Value),
	table_column(Hint),
	table_column(Answer),
	table_column(N),
	table_column(EF),
	table_column(Date),
	html_end(tr),
	table_data(T).
table_data([]) --> 
	[].

table_column(X) -->
	html_begin(td),
	html([
		\[X]
	]),
	html_end(td).

