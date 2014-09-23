function best_novelty = genetic_findbestnoveltyparameters()
%genetic_findbestnaiveaverage find the best average track length
% to use for the naive track estimation

options = gaoptimset;
options = gaoptimset(options,'PopulationSize', 10 );
options = gaoptimset(options,'MigrationDirection', 'both');
options = gaoptimset(options,'MigrationInterval', 3);
options = gaoptimset(options,'MigrationFraction', 0.3);
options = gaoptimset(options,'EliteCount', 4);
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

% learn these three
% 1,novelty_minpeakradius = 50
% 2,novelty_threshold = 0.3
% 3,novelty_kernelsize = 120

best_novelty = ga( @optimise_noveltyparameters, ...
    3, ... % num constraints
    [],[],[],[], ...
    [10,0.01,30], ...
    [150,1,300], ...
    [], ...
    [1,3], ... % int constraints
    options );

end