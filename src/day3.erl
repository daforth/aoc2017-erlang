-module(day3).
-compile(export_all).

%% Step represents the length of an edge of the spiral
%% Distance perpendicular to the edge the number is on
perpdist(Step, _) when Step rem 2 =:= 0 ->
    Step div 2;
perpdist(Step, CornDist) when CornDist < Step ->
    Step div 2;
perpdist(Step, _) ->
    (Step div 2) + 1.

%% Distance parallel to the edge the number is on
pardist(Step, CornDist) ->
    abs((CornDist rem Step) - (Step div 2)).

cdist(N) ->
    %% Positive solution of the equation x(x + 1) = N - 1
    PStep = trunc((math:sqrt(1 + 4 * (N - 1)) - 1) / 2),
    Corner = (PStep * (PStep + 1)) + 1,
    CornDist = N - Corner,
    perpdist(PStep + 1, CornDist) + pardist(PStep + 1, CornDist).
