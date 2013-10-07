-module(ori_chat_server).

-behaviour(gen_server).

-export([start_link/0]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    io:format("ori_chat_server:init()\n"),
    proc_lib:spawn(fun do_accept_loop/0),
    {ok, dummy}.

do_accept_loop() ->
    {ok, LSocket} = gen_tcp:listen(1984, [binary, {packet, 0}, {active, false}, {reuseaddr, true}]),
    accept_loop(LSocket).

accept_loop(LSocket) ->
    {ok, Sock} = gen_tcp:accept(LSocket),
    io:format("accepted"),
    gen_server:cast(?MODULE, {accepted, Sock}),
    accept_loop(LSocket).
    
handle_call(_, _From, State) ->
    {reply, ok, State}.
handle_cast({accepted, Sock}, State) ->
    io:format("I GOT A CONNECTION!!!\n"),
    io:format("~p~n", [gen_tcp:send(Sock, <<"BULBUL AKABULBUL\n">>)]),
    {noreply, State}.
handle_info(_, State) ->
    {noreply, State}.
terminate(_,_) ->
    ok.
code_change(_, State, _) ->
    {ok, State}.
