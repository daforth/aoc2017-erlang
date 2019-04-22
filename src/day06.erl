-module(day6).
-compile(export_all).

realloc(Banks, Max) ->
    realloc_fmax(Banks, Max, []).

realloc_fmax([Max|T], Max, Acc) ->
    realloc_add1(T, Max, [0 | Acc]);
realloc_fmax([H|T], Max, Acc) ->
    realloc_fmax(T, Max, [H | Acc]).

realloc_add1(L, 0, Acc) ->
    lists:reverse(Acc, L);
realloc_add1([], RBlocks, Acc) ->
    realloc_add1(lists:reverse(Acc), RBlocks, []);
realloc_add1([H|T], RBlocks, Acc) ->
    realloc_add1(T, RBlocks - 1, [H+1 | Acc]).

seen(Banks, LSeen) ->
    maps:get(Banks, LSeen, false).

add_seen(Banks, Seen) ->
    Seen#{Banks => true}.

count_cycles(Banks, Seen, Cycles) ->
    Max = lists:max(Banks), 
    NBanks = realloc(Banks, Max),
    case seen(NBanks, Seen) of
        false ->
            count_cycles(NBanks, add_seen(NBanks, Seen), Cycles + 1);
        true ->
            Cycles + 1
    end.

main(_) ->
    {ok, Bin} = file:read_file("../input06"),
    Input = [erlang:binary_to_integer(N) || N <- string:lexemes(Bin, "\t\n")],
    count_cycles(Input, #{}, 0).
    
