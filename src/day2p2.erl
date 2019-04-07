-module(day2p2).
-compile(export_all).


find_divisor(_, []) ->
    false;
find_divisor(N, [H|_]) when N rem H =:= 0 ->
    H;
find_divisor(N, [_|T]) ->
    find_divisor(N, T).

div_pair([H|T]) ->
    case find_divisor(H, T) of
        false ->
            div_pair(T);
        D -> {H, D}
    end.

div_sum(F, Acc) ->
    case file:read_line(F) of
        {ok, Line} ->
            Split = string:split(string:trim(Line), "\t", all),
            NLine = [erlang:list_to_integer(X) || X <- Split],
            Sort = lists:sort(fun (A, B) -> A >= B end, NLine),
            {A, B} = div_pair(Sort),
            div_sum(F, Acc + (A div B));
        eof ->
            Acc
    end.

main() ->
    {ok, F} = file:open("input2", read),
    io:format("~w", [div_sum(F, 0)]),
    file:close(F).
    
