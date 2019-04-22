-module(day8p2).
-compile(export_all).

compare("<", A, B) -> A < B;
compare("<=", A, B) -> A =< B;
compare(">", A, B) -> A > B;
compare(">=", A, B) -> A >= B;
compare("==", A, B) -> A == B;
compare("!=", A, B) -> A /= B.

day8p2([{Var1, Op, N1, Var2, Cmp, N2}|R], Env, Max) ->
    case compare(Cmp, maps:get(Var2, Env, 0), N2) of
        false ->
            day8(R, Env, Max);
        true ->
            Old = maps:get(Var1, Env, 0),
            New = case Op of
                      "inc" -> Old + N1;
                      "dec" -> Old - N1
                  end,
            day8(R, Env#{Var1 => New}, lists:max([Max, New]))
    end;
day8p2([], _, Max) ->
    Max.

parse_line(Line) ->
    [Var1, Op, N1, "if", Var2, Cmp, N2] = string:lexemes(Line, " "),
    {Var1, Op, list_to_integer(N1), Var2, Cmp, list_to_integer(N2)}.

main(_) ->
    {ok, Bin} = file:read_file("../input08"),
    String = binary_to_list(Bin),
    Lines = string:lexemes(String, "\n"),
    Code = [parse_line(L) || L <- Lines],
    day8(Code, #{}, 0).
