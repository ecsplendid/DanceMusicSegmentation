function nov_config = genetic_findbestnoveltyparameters()
%genetic_findbestnaiveaverage find the best average track length
% to use for the naive track estimation

options = gaoptimset;
options = gaoptimset(options,'PopulationSize', 50 );
options = gaoptimset(options,'MigrationDirection', 'both');
options = gaoptimset(options,'MigrationInterval', 3);
options = gaoptimset(options,'MigrationFraction', 0.3);
options = gaoptimset(options,'EliteCount', 10);
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

% learn these three
% 1,novelty_minpeakradius = 10..150 INT
% 2,novelty_threshold = 0.01..1
% 3,novelty_kernelsize = 30..300 INT
% 4,secondsPerTile = 3..40 INT
% 5,bandwidth = 1..15 INT
% 6,cosine_normalization 0.4..1.5
% 7,lpf 800..1950 INT
% 8,hpf 50..500 INT
% 9,solution shift -5..5 INT

lb = [ 10, 0.01, 30, 3, 1, 0.4, 800, 50, -5 ];
ub = [ 150, 1, 300, 40, 15, 1.5, 1950, 500, 5 ];

best_novelty_raw = ga( @optimise_noveltyparameters, ...
    9, ... % num constraints
    [],[],[],[], ...
    lb, ...
    ub, ...
    [], ...
    [1,3,4,5,7,8,9], ... % int constraints
    options );

save( sprintf('results/config_noveltyraw-best_%s.mat', date ), ...
    'best_novelty_raw' );

savefig( sprintf('results/fig_novelty-best_%s.fig', date ) );

nov_config = config_getdefault;
nov_config.novelty_minpeakradius = (best_novelty_raw(1));
nov_config.novelty_threshold = best_novelty_raw(2);
nov_config.novelty_kernelsize = (best_novelty_raw(3));
nov_config.secondsPerTile = (best_novelty_raw(4));
nov_config.bandwidth = (best_novelty_raw(5));
nov_config.cosine_normalization = (best_novelty_raw(6));
nov_config.lowPassFilter = (best_novelty_raw(7));
nov_config.highPassFilter = (best_novelty_raw(8));
nov_config.solution_shift = (best_novelty_raw(9));

save( sprintf('config/config_novelty-best_%s.mat', date ), ...
    'nov_config' );

end