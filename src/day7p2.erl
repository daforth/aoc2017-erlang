-module(day7p2).
-compile(export_all).

%% Note: The solution is made more complicated by taking into account
%% the possibility (not actually occuring in the input tree) of the
%% wrong weighted program being placed on a disk with two towers. In
%% most cases this does not prevent the solution from being unique.

parse_line(L) ->
    [H | T] = string:lexemes(L, "->"),
    [N, WW] = string:lexemes(H, " "),
    Name = erlang:binary_to_list(N),
    Weight = erlang:binary_to_integer(hd(string:lexemes(WW, "() "))),
    Children = [erlang:binary_to_list(C) || C <- string:lexemes(T, ", ")],
    {Name, Weight, Children}.

count_nodes(K, Tree) ->
    {_, C} = maps:get(K, Tree),
    1 + count_nodes_l(C, Tree).
count_nodes_l([H|T], Tree) ->
    count_nodes(H, Tree) + count_nodes_l(T, Tree);
count_nodes_l([], _) ->
    0.

find_root(_Keys = [{K, _, _} | Rest], Tree, Size) ->
    case count_nodes(K, Tree) of
        Size -> K;
        _ -> find_root(Rest, Tree, Size)
    end.

unbalanced([]) -> false;
unbalanced([_]) -> false;
unbalanced(L) -> sets:size(sets:from_list(L)) > 1.

%% Produces the program that supports the deepest unbalanced disk(dud)
%% a tuple representing the higher branch the program stems from, and
%% proplist of the children nodes associated with their own weigth and
%% the total weight of their tree.
find_dud(K, Tree, Branch) ->
    {W, L} = maps:get(K, Tree),
    WeightsPL = case L of
                    [] ->   [];
                    [SC] -> [find_dud(SC, Tree, Branch)];
                    _ ->    [find_dud(P, Tree, {K, P}) || P <- L]
                end,
    Weights = [WW || {_, {_, WW}} <- WeightsPL],
    case unbalanced(Weights) of
        true ->
            throw({K, Branch, WeightsPL});
        false ->
            {K, {W, lists:sum(Weights) + W}}
    end.

tot_weight(K, Tree) ->
    {W, L} = maps:get(K, Tree),
    W + lists:sum([tot_weight(T, Tree) || T <- L]).

%% When the disk contains more than two programs finding the solution
%% is self-contained.
day7p2_simple(Weights) ->
    {Wrong, Right} = case lists:sort([W || {_, {_, W}} <- Weights]) of
                         L = [A, A | _] -> {lists:last(L), A};
                         L -> {hd(L), hd(tl(L))}
                     end,
    Delta = Right - Wrong,
    WNW = hd([NW || {_, {NW, TW}} <- Weights, TW =:= Wrong]),
    WNW + Delta.

day7p2(Root, Tree) ->
    {UDProgram, {OrigParent, OPChild}, Weights} =
        (catch find_dud(Root, Tree, {none, none})),
    Len = length(Weights),
    if Len > 2 ->
            day7p2_simple(Weights);
       Len =:= 2 ->
            %% Have to look at the higher branch to decide wether to
            %% add or subtract from either of the two programs on the
            %% disk
            [{_, {NAW, TAW}}, {_, {NBW, TBW}}] = Weights,
            {NMinW, NMaxW} = if TAW > TBW -> {NBW, NAW};
                                TAW < TBW -> {NAW, NBW}
                             end,
            OtherBranch = hd(lists:filter(fun(P) -> P =/= OPChild end,
                                          element(2, maps:get(OrigParent, Tree)))),
            Delta = tot_weight(OtherBranch, Tree) - tot_weight(OPChild, Tree),
            if Delta > 0 -> NMinW + Delta;
               Delta < 0 -> NMaxW + Delta
            end
    end.

main(_) ->
    {ok, Bin} = file:read_file("../input7"),
    Entries = [parse_line(L) || L <- string:lexemes(Bin, "\n")],
    {TMap, Size} = lists:foldl(fun({N,W,C}, {Map, Size}) ->
                                       {Map#{N => {W, C}}, Size+1}
                               end, {#{}, 0}, Entries),
    Root = find_root(Entries, TMap, Size),
    day7p2(Root, TMap).
