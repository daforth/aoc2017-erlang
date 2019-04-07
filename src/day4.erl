-module(day4).
-compile(export_all).

%% Sorted-List -> Boolean
has_dup([]) ->
    false;
has_dup([H|T]) ->
    has_dup(T, H).
has_dup([P|_], P) ->
    true;
has_dup([H|T], _) ->
    has_dup(T, H);
has_dup([], _) ->
    false.

is_valid(Pass) ->
    not has_dup(lists:sort(Pass)).

main(_) ->
    {ok, Bin} = file:read_file("../input4"),
    Lines = [string:lexemes(L, " ") || L <- string:lexemes(Bin, "\n")],
    length([L || L <- Lines, is_valid(L)]).
