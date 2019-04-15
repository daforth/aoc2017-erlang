-module(day10).
-compile(export_all).

skip_n(String, 0) -> String;
skip_n({Prev, [H | Next]}, N) -> skip_n({[H | Prev], Next}, N - 1);
skip_n({Prev, []}, N) -> skip_n({[], lists:reverse(Prev)}, N). 
    
take_n(String, Len) -> take_n(String, Len, []).
take_n(String, 0, Acc) -> {Acc, String};
take_n({Prev, [H|Next]}, Len, Acc) -> take_n({Prev, Next}, Len - 1, [H|Acc]);
take_n({Prev, []}, Len, Acc) -> take_n({[], lists:reverse(Prev)}, Len, Acc).

put_back([], String) -> String;
put_back([H|T], {Prev, Next}) -> put_back(T, {Prev, [H | Next]}).

reverse_n(String, Len) ->
    {Knot, RestString}  = take_n(String, Len),
    {KPos, Kval} = lists:unzip(Knot),
    RKnot = lists:zip(KPos, lists:reverse(Kval)),
    put_back(RKnot, RestString).

result({_, [{0, Val1} , {1, Val2} | _]}) -> Val1 * Val2;
result({Prev, [{0, Val1}]}) -> Val1 * element(2, lists:last(Prev));
result({Prev, [H|T]}) -> result({[H|Prev], T});
result({Prev, []}) -> result({[], lists:reverse(Prev)}).

day10([{Len, Skip} | Rest], String) ->
    RString = reverse_n(String, Len),
    day10(Rest, skip_n(RString, Len + Skip));
day10([], String) ->
    result(String).

main(_) ->
    Input = [212,254,178,237,2,0,1,54,167,92,117,125,255,61,159,164],
    WSkips = lists:zip(Input, lists:seq(0, length(Input) - 1)),
    String = lists:seq(0, 255),
    WPos = lists:zip(String, String),
    day10(WSkips, {[], WPos}).

