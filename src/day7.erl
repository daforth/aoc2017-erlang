-module(day7).
-compile(export_all).

parse_line(L) ->
    [H | T] = string:lexemes(L, "->"),
    [N, WW] = string:lexemes(H, " "),
    Name = erlang:binary_to_list(N),
    Weight = erlang:binary_to_integer(hd(string:lexemes(WW, "() "))),
    Children = [erlang:binary_to_list(C) || C <- string:lexemes(T, ", ")],
    {Name, Weight, Children}.

count_nodes(K, Map) ->
    {_, C} = maps:get(K, Map),
    1 + count_nodes_l(C, Map).
count_nodes_l([H|T], Map) ->
    count_nodes(H, Map) + count_nodes_l(T, Map);
count_nodes_l([], _) ->
    0.

find_root(_Keys = [{K, _, _} | Rest], Map, Size) ->
    case count_nodes(K, Map) of
        Size -> K;
        _ -> find_root(Rest, Map, Size)
    end.

main(_) ->
    {ok, Bin} = file:read_file("../input7"),
    Entries = [parse_line(L) || L <- string:lexemes(Bin, "\n")],
    {TMap, Size} = lists:foldl(fun({N,W,C}, {Map, Size}) ->
                                       {Map#{N => {W, C}}, Size+1}
                               end, {#{}, 0}, Entries),
    find_root(Entries, TMap, Size).
