-module(smtp).

-export([send/6]).


send(To, From, Subject, Message, Server, PortNo)->
	{ok,Sock}=gen_tcp:connect(Server,PortNo,[{active, false}]),
	gen_tcp:send(Sock,"QUIT"),
	{ok, Response}=gen_tcp:recv(Sock, 0),
	io:fwrite("~s~n", [Response])
.	