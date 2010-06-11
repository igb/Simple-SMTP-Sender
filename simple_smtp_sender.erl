-module(simple_smtp_sender).

-export([send/4, send/5, send/6, send/7]).

send(To, From, Subject, Message)->
	Server="localhost",
	send(To, From, Subject, Message, Server).

send(To, From, Subject, Message, Server)->
	PortNo=25,	
	send(To, From, Subject, Message, Server, PortNo).

send(To, From, Subject, Message, Server, PortNo)->
	{ok, Hostname}=inet:gethostname(),
	send(To, From, Subject, Message, Server, PortNo, Hostname).
	
send(To, From, Subject, Message, Server, PortNo, LocalDomain)->
	{ok,Sock}=gen_tcp:connect(Server,PortNo,[{active, false}]),
	{ok, "220"++_}=gen_tcp:recv(Sock, 0),
	gen_tcp:send(Sock, lists:append(["HELO ", LocalDomain, [13, 10]])),
	{ok, "250"++_}=gen_tcp:recv(Sock, 0),
	gen_tcp:send(Sock, lists:append(["MAIL FROM: ", From, [13, 10]])),
	{ok, "250"++_}=gen_tcp:recv(Sock, 0),
	gen_tcp:send(Sock, lists:append(["RCPT TO: ", To, [13, 10]])),
	{ok, "250"++_}=gen_tcp:recv(Sock, 0),
	gen_tcp:send(Sock, lists:append(["DATA", [13, 10]])),
	{ok, "354"++_}=gen_tcp:recv(Sock, 0),
	gen_tcp:send(Sock, lists:append(["Subject: ", Subject, [13, 10],[13, 10]])),
	gen_tcp:send(Sock, lists:append([Message])),
	gen_tcp:send(Sock, lists:append([[13, 10],".",[13, 10],[13, 10]])),
	{ok, "250"++_}=gen_tcp:recv(Sock, 0),
	gen_tcp:send(Sock,lists:append("QUIT", [13, 10])),
	{ok, "221"++_}=gen_tcp:recv(Sock, 0),
	gen_tcp:close(Sock),
	ok.