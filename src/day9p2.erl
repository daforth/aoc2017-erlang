-module(day9p2).
-compile(export_all).

day9p2([$!, _ | Rest], State, Sum) -> day9p2(Rest, State, Sum);
day9p2([$> | Rest], garbage, Sum) -> day9p2(Rest, normal, Sum);
day9p2([_ | Rest], garbage, Sum) -> day9p2(Rest, garbage, Sum + 1);
day9p2([$< | Rest], normal, Sum) -> day9p2(Rest, garbage, Sum);
day9p2([_ | Rest], normal, Sum) -> day9p2(Rest, normal, Sum);
day9p2([], normal, Sum) -> Sum.

main(_) ->
    {ok, Bin} = file:read_file("../input9"),
    String = binary_to_list(Bin),
    day9p2(String, normal, 0).
