-module(day4p2).
-compile(export_all).

%% inspiration from day 4, part 1 of https://ferd.ca/advent-of-code-2017.html
main(_) ->
    {ok, Bin} = file:read_file("../input4"),
    length([L || L <- string:lexemes(Bin, "\n"),
                WL <- [string:lexemes(L, " ")],
                SW <- [[lists:sort(erlang:binary_to_list(W)) || W <- WL]],
                length(SW) == sets:size(sets:from_list(SW))]).
