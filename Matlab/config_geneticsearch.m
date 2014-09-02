%% options setup

options = gaoptimset;

options = gaoptimset(options,'PopulationSize', 100);
options = gaoptimset(options,'EliteCount', 15);
options = gaoptimset(options,'Generations', 30);
options = gaoptimset(options,'StallGenLimit', 5);
options = gaoptimset(options,'Display', 'iter');
options = gaoptimset(options,'PlotFcns', {  @gaplotbestf @gaplotbestindiv @gaplotdistance @gaplotexpectation @gaplotgenealogy @gaplotrange @gaplotscorediversity @gaplotscores @gaplotselection @gaplotstopping @gaplotmaxconstr });
options = gaoptimset(options,'Vectorized', 'off');
options = gaoptimset(options,'UseParallel', 1 );


%% for finding best optimise_trackplacementmean

cfg_trkplacemean = ga( @optimise_trackplacementmean, ...
    22, ... % num constraints
    [],[],[],[], ...
    config_optimdrivebounds_lowerbounds, ...
    config_optimdrivebounds_upperbounds, ...
    [], ...
    [14,15,16,17,18,19,20,21,22], ... % int constraints
    options );

savefig('results/optimise_trackplacementmean.fig');

% run the full experiment
ag1 = run_experiments( config_optimdrive(cfg_trkplacemean, 2) );
ag1.description = 'best mean';
save results/cfg_trkplacemean.mat ag1;

%% for finding best optimise_trackplacementheuristic

cfg_trkplaceheur = ga( @optimise_trackplacementheuristic, ...
    22, ... % num constraints
    [],[],[],[], ...
    config_optimdrivebounds_lowerbounds, ...
    config_optimdrivebounds_upperbounds, ...
    [], ...
    [14,15,16,17,18,19,20,21,22], ... % int constraints
    options );

savefig('results/optimise_trackplacementheuristic.fig');

% run the full experiment
ag2 = run_experiments( config_optimdrive(cfg_trkplaceheur, 2) );
ag1.description = 'best heuristic';
save results/cfg_trkplaceheur.mat ag2;

%% for finding best optimise_trackplacementstd

cfg_trkplacestd = ga( @optimise_trackplacementstd, ...
    22, ... % num constraints
    [],[],[],[], ...
    config_optimdrivebounds_lowerbounds, ...
    config_optimdrivebounds_upperbounds, ...
    [], ...
    [14,15,16,17,18,19,20,21,22], ... % int constraints
    options );

savefig('results/optimise_trackplacementstd.fig');

% run the full experiment
ag3 = run_experiments( config_optimdrive(cfg_trkplacestd, 2) );
ag1.description = 'best std';
save results/cfg_trkplacestd.mat ag3;

%% run a totally random one for comparison

ag4 = run_experiments( config_optimdrive(config_optimdrivebounds_randomstart, 2) );
ag1.description = 'totally random';
save results/cfg_random.mat ag4;

%% for estimating the number of segments

cfg_nosegs = ga( @optimise_tracknumberestimate, ...
    22, ... % num constraints
    [],[],[],[], ...
    config_optimdrivebounds_lowerbounds, ...
    config_optimdrivebounds_upperbounds, ...
    [], ...
    [14,15,16,17,18,19,20,21,22], ... % int constraints
    options );

savefig('results/optimise_tracknumberestimate.fig');

save results/cfg_nosegs.mat cfg_nosegs