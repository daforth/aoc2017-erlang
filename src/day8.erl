-module(day8).
-compile(export_all).

compare("<", A, B) -> A < B;
compare("<=", A, B) -> A =< B;
compare(">", A, B) -> A > B;
compare(">=", A, B) -> A >= B;
compare("==", A, B) -> A == B;
compare("!=", A, B) -> A /= B.

day8([{Var1, Op, N1, Var2, Cmp, N2}|R], Env) ->
    case compare(Cmp, maps:get(Var2, Env, 0), N2) of
        false ->
            day8(R, Env);
        true ->
            Old = maps:get(Var1, Env, 0),
            New = case Op of 
                      "inc" -> Old + N1;
                      "dec" -> Old - N1
                  end,
            day8(R, Env#{Var1 => New})
    end;
day8([], Env) ->
    lists:max(maps:values(Env)).

parse_line(Line) ->
    [Var1, Op, N1, "if", Var2, Cmp, N2] = string:lexemes(Line, " "),
    {Var1, Op, list_to_integer(N1), Var2, Cmp, list_to_integer(N2)}.
    
main(_) ->
    {ok, Bin} = file:read_file("../input8"),
    String = binary_to_list(Bin),
    Lines = string:lexemes(String, "\n"),
    Code = [parse_line(L) || L <- Lines],
    day8(Code, #{}).

