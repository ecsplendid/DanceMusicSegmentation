%% options setup

options = gaoptimset;
options = gaoptimset(options,'PopulationSize', [ 50 ] );
options = gaoptimset(options,'MigrationDirection', 'both');
options = gaoptimset(options,'MigrationInterval', 3);
options = gaoptimset(options,'MigrationFraction', 0.3);
options = gaoptimset(options,'EliteCount', 7);
options = gaoptimset(options,'CrossoverFraction', 0.5);
options = gaoptimset(options,'Generations', 100);
options = gaoptimset(options,'StallGenLimit', 5);
options = gaoptimset(options,'Display', 'iter');
options = gaoptimset(options,'PlotFcns', {  ...
    @gaplotbestf @gaplotbestindiv @gaplotdistance ...
    @gaplotexpectation @gaplotrange ...
    @gaplotscorediversity @gaplotscores @gaplotselection...
    @gaplotstopping @gaplotmaxconstr });
options = gaoptimset(options,'Vectorized', 'off');
options = gaoptimset(options,'UseParallel', 1 );

gauss = 1;
estimate_tracks = 1;



%% mean for finding best optimise_trackplacementmean

cfg_trkplacemean = ga( @optimise_trackplacementmean, ...
    28, ... % num constraints
    [],[],[],[], ...
    config_optimdrivebounds(0, gauss), ...
    config_optimdrivebounds(1, gauss), ...
    [], ...
    [14,15,16,17,18,19,20,21,26,27,28], ... % int constraints
    options );

savefig('results/optimise_trackplacementmean.fig');

% run the full experiment
all = run_experiments( ...
    config_optimdrive(cfg_trkplacemean, 2, estimate_tracks ), ...
    'best mean' );
save results/cfg_trkplacemean.mat all;


