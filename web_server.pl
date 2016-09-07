:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_error)).
:- use_module(library(http/html_write)).
:- use_module(library(http/http_parameters)).
server(Port) :-
	http_server(http_dispatch, [port(Port)]).

:- http_handler(/, say_hi, [prefix]).
:- http_handler('/test', reply, []).
:- http_handler('/test2', response, []).

say_hi(_Request) :- 
	format('Content-type: text/html~n~n'),
	format('<html><body><form action="test">First name:<br><input type="text" name="firstname" value="Mickey"><br>Last name:<br><input type="text" name="lastname" value="Mouse"><br><br><input type="submit" value="Submit"></form><p>If you click the "Submit" button, the form-data will be sent to a page called "action_page.php".</p></body></html>').


reply(Request) :-
	reply_html_page(
		title('Hello!'),
		[\page_reply(Request)]).

response(Request) :-
	reply_html_page(
		title('Huzzah!'),
		[\page_response(Request)]).

page_reply(Request) -->
	{
		catch(
			http_parameters(Request,
				[
					firstname(Firstname, [default(blah)]),
					lastname(Lastname, [default(blah)])
				]),
			_E,
			fail),
		!
	},
	html(
		[
		h1('Got form input'),
		p('As follows:'),
		p('First name is ~w'-Firstname),
		p('Last name is ~w'-Lastname),
		p('Score of 0-5')
		]
	),
	html_begin(table(border(1), align(center), width('80%'))),
	html_begin(th),
	html([p('Hello! How\'s it going?!')]),
	html_end(th),
	html_end(table),
	html_begin(form(action('test2'))),
	html(
		[
		\['<hr/>', '<br/>'],
		p('Enter a score 0-5:'),
		\['<br/>'],
		p('0 - Couldn\'t remember at all'),
		p('1 - Wrong but, correct response remembered'),
		p('2 - Wrong but, correct response easily remembered'),
		p('3 - Response recalled, serious difficulty'),
		p('4 - Response recallled, hesitation'),
		p('5 - Response easily recalled'),
		\['<br/>'],
		\['<br/>'],
		p('Score:')
		]
	),
	html_begin(input(type('text'),name('score'),value('3'))),
	html_end(input),
	html_begin(input(type('submit'),value('Submit'))),
	html_end(input),
	html_end(form).

page_reply(_Request) -->
	html([
		h1('Oops!'),
		p('Some parameter wasn\'t valid')
	]).

page_response(Request) -->
	{
		catch(
			http_parameters(Request,
				[
					score(Score, [])
				]),
			_E,
			fail),
		!
	},
	html(
		[
		h1('Got form input'),
		p('As follows:'),
		p('Score is ~w'-Score),
		html_begin(form(action('test2'))),
		input(type('text'),name('Score'),value('3'))
		]
	).

page_response(_Request) -->
	html([
		h1('Oops!'),
		p('Some parameter wasn\'t valid')
	]).

