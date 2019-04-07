%% AOC 2017 solutions @forht 
-module(day1).
-compile(export_all).

repeated(List = [H | _]) ->
    repeated(List, H, []).
repeated([First | []], First, Acc) ->
    [First | Acc];
repeated([_ | []], _, Acc) ->
    Acc;
repeated([A, A | T], First, Acc) ->
    repeated([A | T], First, [A | Acc]);
repeated([_, H | T], First, Acc) ->
    repeated([H | T], First, Acc).

main(_) ->
    {ok, Bin} = file:read_file("../input1"),
    CodeList = string:trim(erlang:binary_to_list(Bin)),
    DList = lists:map(fun(C) -> C - $0 end, CodeList),
    Repeated = repeated(DList),
    io:format("~w", [lists:sum(Repeated)]).
