%So this file will contain my attempt at a restful interface to the
% webapplication. Instead of displaying the HTML from Prolog itself
% (because JSP and JSP-alikes are horrific). It's cool, but ultimately
% maintaining it is horrible.

:- use_module(library(http/http_dispatch)).
:- use_module(library(http/thread_httpd)).
:- use_module(library(http/html_write)).

server(Port) :-
  http_server(http_dispatch, [port(Port)]).


%Redirect everything to welcome that's not valid.
:- http_handler(/,welcome, [prefix]).
%Return something. Referenced from javascript in hello.html
:- http_handler('/get_dummy_string', get_dummy_string, []).
%The loverly stylesheet we're serving.
:- http_handler('/style.css',get_styles,[]).

%Serve an html file
welcome(Request) :-
  http_reply_file('hello.html', [],Request).

%This is because we said 'Hey, redirect everything to welcome that's not valid
%So we have to serve style.css explicitly
get_styles(Request) :-
  http_reply_file('style.css',[],Request).

%The 'out' stream is pointing at the correct place already
% Per:http://www.pathwayslms.com/swipltuts/html/ CH2.2
get_dummy_string(_Request) :-
  %Format outputs with some stuff.
  %Might be able to return Content-type text/javascript for json?
  format('Content-type: text/plain~n~n'),
  format('Hello again!~n').
