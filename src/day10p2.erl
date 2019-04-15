-module(day10p2).
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

rewind({Prev, Next = [{0, _} | _]}) -> Next ++ lists:reverse(Prev);
rewind({Prev, [H | T]}) -> rewind({[H|Prev], T});
rewind({Prev, []}) ->  rewind({[], lists:reverse(Prev)}).

slice16([]) -> [];
slice16(List = [_ | _]) -> {H, T} = lists:split(16, List), [H | slice16(T)].

day10p2([Len | Rest], Skip, String, Round, Input) ->
    RString = reverse_n(String, Len),
    day10p2(Rest, (Skip + 1) rem 256, skip_n(RString, Len + Skip), Round, Input);
day10p2([], _, String, 64, _) ->
    {_, LString} = lists:unzip(rewind(String)),
    Res = [lists:foldl(fun(X, Acc) -> X bxor Acc end, 0, Block) || Block <- slice16(LString)],
    UHash = [case length(S) of 2 -> S; 1 -> [$0 | S] end ||
            N <- Res, S <- [integer_to_list(N,16)]],
    string:to_lower(lists:flatten(UHash));
day10p2([], Skip, String, Round, Input) ->
    day10p2(Input, Skip, String, Round + 1, Input).

main(_) ->
    Input = "212,254,178,237,2,0,1,54,167,92,117,125,255,61,159,164"
        ++ [17, 31, 73, 47, 23],
    String = lists:seq(0, 255),
    WPos = lists:zip(String, String),
    day10p2(Input, 0, {[], WPos}, 1, Input).

