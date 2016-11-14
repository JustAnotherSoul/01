:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_error)).
:- use_module(library(http/html_write)).
:- use_module(library(http/http_parameters)).
:- ensure_loaded(../algorithm/memorization).
:- ensure_loaded(../data/entries).
server(Port) :-
	http_server(http_dispatch, [port(Port)]).

:- http_handler(/, welcome, [prefix]).
:- http_handler('/memorize.html', begin_memorization, []).
:- http_handler('/response.html', respond, []). 

welcome(Request) :-
	reply_html_page(
		title('Welcome!'),[\welcome_page(Request)]).
		
begin_memorization(_Request) :- 
	get_time(CurrentTime),
	findall(Key, (entry(Key,_Value,_N,_EF,Date), CurrentTime > Date), Z), create_ui(Z), store('entries2.pl').

respond(_Request) :-
	reply_html_page(
		title('Rate your response'),
		p('Under construction!')).

create_ui(Z) :-
	reply_html_page(
		title('Huzzah!'),
		[\prompt_form(_Request, Z)]).

welcome_page(_Request) -->
		html_begin(p),
		['Hello and welcome! Click '],
		html_begin(a(href('memorize.html'))),
		['here'],
		html_end(a),
		[' to be taken to the memorization portion of the site'],
		html_end(p).

construct_user_interface(_Request, Z) -->
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
	['Hint ', Hint,'<br/>'],
	table_data(T).
table_data([]) --> 
	[].

table_column(X) -->
	html_begin(td),
	html([
		\[X]
	]),
	html_end(td).

prompt_form(_Request, [H|T]) -->
	{
		entry(H, Value, N, EF, Date),
		data(Value, Hint, Answer)
	},
	html_begin(form(action('response.html'))),
	['Hint: ',Hint, '<br/>','Your Answer: '],
	html_begin(input(type(text), name(answer))),
	html_begin(input(type(submit), value('Submit'))).
	
response_form(_Request, [H|T]) -->
	html_begin(form(action())),
	['Actual: ',
