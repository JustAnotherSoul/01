:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_error)).
:- use_module(library(http/html_write)).
:- use_module(library(http/http_parameters)).
server(Port) :-
	http_server(http_dispatch, [port(Port)]).

:- http_handler(/, say_hi, [prefix]).
:- http_handler('/test', reply, []).

say_hi(_Request) :- 
	format('Content-type: text/html~n~n'),
	format('<html><body><form action="test">First name:<br><input type="text" name="firstname" value="Mickey"><br>Last name:<br><input type="text" name="lastname" value="Mouse"><br><br><input type="submit" value="Submit"></form><p>If you click the "Submit" button, the form-data will be sent to a page called "action_page.php".</p></body></html>').

reply(Request) :-
	reply_html_page(
		title('Hello!'),
		[\page_reply(Request)]).


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
		p('Last name is ~w'-Lastname)
		]
	).
page_reply(_Request) -->
	html([
		h1('Oops!'),
		p('Some parameter wasn\'t valid')
	]).

