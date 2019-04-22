-module(day2).
-compile(export_all).

minmax([H|T]) ->
    minmax(T, H, H).
minmax([], Min, Max) ->
    {Min, Max};
minmax([H|T], Min, Max) when H < Min ->
    minmax(T, H, Max);
minmax([H|T], Min, Max) when H > Max ->
    minmax(T, Min, H);
minmax([_|T], Min, Max) ->
    minmax(T, Min, Max).

delta_minmax(L) ->
    {Min, Max} = minmax(L),
    Max - Min.

checksum(F, Acc) ->
    case file:read_line(F) of
        {ok, Line} ->
            Split = string:split(string:trim(Line), "\t", all),
            NLine = [erlang:list_to_integer(X) || X <- Split],
            checksum(F, Acc + delta_minmax(NLine));
        eof ->
            Acc
    end.

main() ->
    {ok, F} = file:open("input02", read),
    io:format("~w", [checksum(F, 0)]),
    file:close(F).
    
