-module(day3p2).
-compile(export_all).

%% turn left when square to the left of Dir is not filled
next_dir(LV, Dir) when LV > 0 -> Dir;
next_dir(_, u) -> l;
next_dir(_, l) -> d;
next_dir(_, d) -> r;
next_dir(_, r) -> u.

next_square({X, Y}, u) ->
    {X, Y+1};
next_square({X, Y}, l) ->
    {X-1, Y};
next_square({X, Y}, d) ->
    {X, Y-1};
next_square({X, Y}, r) ->
    {X+1, Y}.

%% produces {behind-point, behind-left-point, left-point, forw-left-point}
get_neighbors({X, Y}, u) ->
    [{X, Y - 1}, {X - 1, Y - 1}, {X - 1, Y}, {X - 1, Y + 1}];
get_neighbors({X, Y}, l) ->
    [{X + 1, Y}, {X + 1, Y - 1}, {X, Y - 1}, {X - 1, Y - 1}];
get_neighbors({X, Y}, d) ->
    [{X, Y + 1}, {X + 1, Y + 1}, {X + 1, Y}, {X + 1, Y - 1}];
get_neighbors({X, Y}, r) ->
    [{X - 1, Y}, {X - 1, Y + 1}, {X, Y + 1}, {X + 1, Y + 1}].

spiral_sum(Current, Dir, Mem, N) ->
    Nbors = get_neighbors(Current, Dir),
    Vals = [_,_,LV,_] = [maps:get(P, Mem, 0) || P <- Nbors],
    case lists:sum(Vals) of
        Sum when Sum > N ->
            Sum;
        Sum ->
            NDir = next_dir(LV, Dir),
            spiral_sum(next_square(Current, NDir), 
                       NDir, 
                       Mem#{Current => Sum},
                       N)
    end.
        
spiral_sum(N) ->
    spiral_sum({1,0}, r, #{{0,0} => 1}, N).
