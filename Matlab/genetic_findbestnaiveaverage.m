function best_average = genetic_findbestnaiveaverage()
%genetic_findbestnaiveaverage find the best average track length
% to use for the naive track estimation

options = gaoptimset;
options = gaoptimset(options,'PopulationSize', 5 );
options = gaoptimset(options,'MigrationDirection', 'both');
options = gaoptimset(options,'MigrationInterval', 3);
options = gaoptimset(options,'MigrationFraction', 0.3);
options = gaoptimset(options,'EliteCount', 2);
options = gaoptimset(options,'CrossoverFraction', 0.5);
options = gaoptimset(options,'Generations', 100);
options = gaoptimset(options,'StallGenLimit', 3);
options = gaoptimset(options,'Display', 'iter');
options = gaoptimset(options,'PlotFcns', {  ...
    @gaplotbestf @gaplotbestindiv @gaplotdistance ...
    @gaplotexpectation @gaplotrange ...
    @gaplotscorediversity @gaplotscores @gaplotselection...
    @gaplotstopping @gaplotmaxconstr });
options = gaoptimset(options,'Vectorized', 'off');
options = gaoptimset(options,'UseParallel', 1 );

best_average = ga( @optimise_naiveaverage, ...
    1, ... % num constraints
    [],[],[],[], ...
    100, ...
    600, ...
    [], ...
    1, ... % int constraints
    options );

end