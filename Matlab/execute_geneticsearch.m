function execute_geneticsearch( ...
    desc, optimization_function, ...
    bound_function, gauss, execute_full )
%EXECUTE_GENETICSEARCH run the genetic search algorithm

diary on;

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

best_configraw = ga( optimization_function, ...
    28, ... % num constraints
    [],[],[],[], ...
    bound_function(0, gauss), ...
    bound_function(1, gauss), ...
    [], ...
    [14,15,16,17,18,19,20,21,26,27,28], ... % int constraints
    options );

savefig( sprintf('results/fig_%s_%s.fig', desc, date ) );

estimate_tracks = 1;
dataset = 2;

% run the full experiment
config = config_optimdrive(best_configraw, dataset, estimate_tracks);
save( sprintf('results/config_%s_%s.mat', desc, date ), 'config' );

if execute_full 
    agr = run_experiments( config, desc );
    save( sprintf('results/agres_%s_%s.mat', desc, date ), 'agr' );
end

end

