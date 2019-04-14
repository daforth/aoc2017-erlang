-module(day9).
-compile(export_all).

day9([$!, _ | Rest], State, Level, Sum) ->
    day9(Rest, State, Level, Sum);
day9([$> | Rest], garbage, Level, Sum) ->
    day9(Rest, normal, Level, Sum);
day9([_ | Rest], garbage, Level, Sum) ->
    day9(Rest, garbage, Level, Sum);
day9([$< | Rest], normal, Level, Sum) ->
    day9(Rest, garbage, Level, Sum);
day9([${ | Rest], normal, Level, Sum) ->
    day9(Rest, normal, Level + 1, Sum);
day9([$} | Rest], normal, Level, Sum ) ->
    day9(Rest, normal, Level - 1, Sum + Level);
day9([_ | Rest], normal, Level, Sum) ->
    day9(Rest, normal, Level, Sum);
day9([], normal, 0, Sum) ->
    Sum.

main(_) ->
    {ok, Bin} = file:read_file("../input9"),
    String = binary_to_list(Bin),
    day9(String, normal, 0, 0).
