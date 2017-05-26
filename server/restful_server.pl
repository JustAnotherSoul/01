%So this file will contain my attempt at a restful interface to the
% webapplication. Instead of displaying the HTML from Prolog itself
% (because JSP and JSP-alikes are horrific). It's cool, but ultimately
% maintaining it is horrible.

:- use_module(library(http/http_dispatch)).
:- use_module(library(http/thread_httpd)).
:- use_module(library(http/html_write)).

server(Port) :-
  http_server(http_dispatch, [port(Port)]).

:- http_handler(/,welcome, [prefix]).
:- http_handler('/get_dummy_string', getdummystring, []).

welcome(Request) :-
  http_reply_file('hello.html', [],Request).

getdummystring(_Request) :-
  format('Content-type: text/plain~n~n'),
  format('Hello again!~n').
