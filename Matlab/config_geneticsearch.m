%% options setup

options = gaoptimset;
options = gaoptimset(options,'PopulationSize', [50 50] );
options = gaoptimset(options,'MigrationDirection', 'both');
options = gaoptimset(options,'MigrationInterval', 3);
options = gaoptimset(options,'MigrationFraction', 0.3);
options = gaoptimset(options,'EliteCount', 10);
options = gaoptimset(options,'CrossoverFraction', 0.5);
options = gaoptimset(options,'Generations', 20);
options = gaoptimset(options,'StallGenLimit', 4);
options = gaoptimset(options,'Display', 'iter');
options = gaoptimset(options,'PlotFcns', {  ...
    @gaplotbestf @gaplotbestindiv @gaplotdistance ...
    @gaplotexpectation @gaplotgenealogy @gaplotrange ...
    @gaplotscorediversity @gaplotscores @gaplotselection...
    @gaplotstopping @gaplotmaxconstr });
options = gaoptimset(options,'Vectorized', 'off');
options = gaoptimset(options,'UseParallel', 1 );
options = gaoptimset(options,'InitialPopulation', ...
    config_optimdrivebounds_randomstart() );

gauss = 1;

%% only sum+gauss cost matrix

cfg_trkplace_sumgauss = ga( @optimise_trackplacementmean, ...
    25, ... % num constraints
    [],[],[],[], ...
    config_optimdrivebounds_onlysum(0, gauss), ...
    config_optimdrivebounds_onlysum(1, gauss), ...
    [], ...
    [14,15,16,17,18,19,20,21], ... % int constraints
    options );

savefig('results/cfg_trkplace_sumgauss.fig');

save results/cfg_trkplace_sumgauss_onlyconfig.mat cfg_trkplace_sumgauss;

% run the full experiment
sum_gauss = run_experiments( config_optimdrive(cfg_trkplace_sumgauss, 2) );
sum_gauss.description = 'sum + gauss';
save results/cfg_trkplace_sumgauss.mat sum_gauss;

%% mean for finding best optimise_trackplacementmean

cfg_trkplacemean = ga( @optimise_trackplacementmean, ...
    25, ... % num constraints
    [],[],[],[], ...
    config_optimdrivebounds(0, gauss), ...
    config_optimdrivebounds(1, gauss), ...
    [], ...
    [14,15,16,17,18,19,20,21], ... % int constraints
    options );

savefig('results/optimise_trackplacementmean.fig');

% run the full experiment
all = run_experiments( config_optimdrive(cfg_trkplacemean, 2) );
all.description = 'best mean';
save results/cfg_trkplacemean.mat all;

%% only contig+gauss cost matrix

cfg_trkplace_contiggauss = ga( @optimise_trackplacementmean, ...
    25, ... % num constraints
    [],[],[],[], ...
    config_optimdrivebounds_onlycontig(0, gauss), ...
    config_optimdrivebounds_onlycontig(1, gauss), ...
    [], ...
    [14,15,16,17,18,19,20,21], ... % int constraints
    options );

savefig('results/cfg_trkplace_contiggauss.fig');

% run the full experiment
contiggauss = run_experiments( config_optimdrive(cfg_trkplace_contiggauss, 2) );
contiggauss.description = 'contig + gauss';
save results/cfg_trkplace_contiggauss.mat contiggauss;

%% only evolution+gauss cost matrix

cfg_trkplace_evogauss = ga( @optimise_trackplacementmean, ...
    25, ... % num constraints
    [],[],[],[], ...
    config_optimdrivebounds_onlyevolution(0, gauss), ...
    config_optimdrivebounds_onlyevolution(1, gauss), ...
    [], ...
    [14,15,16,17,18,19,20,21], ... % int constraints
    options );

savefig('results/optimise_trackplacement_evogauss.fig');

% run the full experiment
evogauss = run_experiments( config_optimdrive(cfg_trkplace_evogauss, 2) );
evogauss.description = 'evolution + gauss';
save results/cfg_trkplace_evogauss.mat evogauss;

%% only sym+gauss cost matrix

cfg_trkplace_symgauss = ga( @optimise_trackplacementmean, ...
    25, ... % num constraints
    [],[],[],[], ...
    config_optimdrivebounds_onlysym(0, gauss), ...
    config_optimdrivebounds_onlysym(1, gauss), ...
    [], ...
    [14,15,16,17,18,19,20,21], ... % int constraints
    options );

savefig('results/optimise_trackplacement_symgauss.fig');

% run the full experiment
symgauss = run_experiments( config_optimdrive(cfg_trkplace_symgauss, 2) );
symgauss.description = 'sym + gauss';
save results/cfg_trkplace_symgauss.mat symgauss;

%% for estimating the number of segments

cfg_evolution = ga( @optimise_tracknumberestimate, ...
    25, ... % num constraints
    [],[],[],[], ...
    config_optimdrivebounds_lowerbounds, ...
    config_optimdrivebounds_upperbounds, ...
    [], ...
    [14,15,16,17,18,19,20,21], ... % int constraints
    options );

savefig('results/optimise_tracknumberestimate.fig');

save results/cfg_nosegs.mat cfg_nosegs

%% for finding best optimise_trackplacementheuristic

cfg_trkplaceheur = ga( @optimise_trackplacementheuristic, ...
    25, ... % num constraints
    [],[],[],[], ...
    config_optimdrivebounds(0), ...
    config_optimdrivebounds(1), ...
    [], ...
    [14,15,16,17,18,19,20,21], ... % int constraints
    options );

savefig('results/optimise_trackplacementheuristic.fig');

% run the full experiment
ag2 = run_experiments( config_optimdrive(cfg_trkplaceheur, 2) );
ag2.description = 'best heuristic';
save results/cfg_trkplaceheur.mat ag2;

%% run a totally random one for comparison

ag4 = run_experiments( config_optimdrive(config_optimdrivebounds_randomstart, 2) );
ag4.description = 'totally random';
save results/cfg_random.mat ag4;