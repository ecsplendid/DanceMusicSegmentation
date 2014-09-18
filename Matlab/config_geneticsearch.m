%% options setup

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

gauss = 1;
estimate_tracks = 1;

%% only evolution+gauss cost matrix

cfg_trkplace_evogauss = ga( @optimise_trackplacementmean, ...
    28, ... % num constraints
    [],[],[],[], ...
    config_optimdrivebounds_onlyevolution(0, gauss), ...
    config_optimdrivebounds_onlyevolution(1, gauss), ...
    [], ...
    [14,15,16,17,18,19,20,21,26,27,28], ... % int constraints
    options );

savefig('results/optimise_trackplacement_evogauss.fig');

% run the full experiment
evogauss = run_experiments( ...
    config_optimdrive(cfg_trkplace_evogauss, 2, estimate_tracks), ...
    'evolution + gauss' );
save results/cfg_trkplace_evogauss.mat evogauss;

%% only sym+gauss cost matrix

cfg_trkplace_symgauss = ga( @optimise_trackplacementmean, ...
    28, ... % num constraints
    [],[],[],[], ...
    config_optimdrivebounds_onlysym(0, gauss), ...
    config_optimdrivebounds_onlysym(1, gauss), ...
    [], ...
    [14,15,16,17,18,19,20,21,26,27,28], ... % int constraints
    options );

savefig('results/optimise_trackplacement_symgauss.fig');

% run the full experiment
symgauss = run_experiments( ...
    config_optimdrive(cfg_trkplace_symgauss, 2, estimate_tracks), ...
    'sym + gauss' );
save results/cfg_trkplace_symgauss.mat symgauss;


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

%% only contig+gauss cost matrix

cfg_trkplace_contiggauss = ga( @optimise_trackplacementmean, ...
    28, ... % num constraints
    [],[],[],[], ...
    config_optimdrivebounds_onlycontig(0, gauss), ...
    config_optimdrivebounds_onlycontig(1, gauss), ...
    [], ...
    [14,15,16,17,18,19,20,21,26,27,28], ... % int constraints
    options );

savefig('results/cfg_trkplace_contiggauss.fig');

% run the full experiment
contiggauss = run_experiments( ...
    config_optimdrive(cfg_trkplace_contiggauss, 2, estimate_tracks), ...
    'contig + gauss' );

save results/cfg_trkplace_contiggauss.mat contiggauss;

%% only sum+gauss cost matrix

cfg_trkplace_sumgauss = ga( @optimise_trackplacementmean, ...
    28, ... % num constraints
    [],[],[],[], ...
    config_optimdrivebounds_onlysum(0, gauss), ...
    config_optimdrivebounds_onlysum(1, gauss), ...
    [], ...
    [14,15,16,17,18,19,20,21,26,27,28], ... % int constraints
    options );

savefig('results/cfg_trkplace_sumgauss.fig');

save results/cfg_trkplace_sumgauss_onlyconfig.mat cfg_trkplace_sumgauss;

% run the full experiment
sum_gauss = run_experiments( ...
    config_optimdrive(cfg_trkplace_sumgauss, 2, estimate_tracks), ...
    'sum + gauss' );
save results/cfg_trkplace_sumgauss.mat sum_gauss;


%% ------------------------

gauss = 0;

%% only sum cost matrix

cfg_trkplace_sum = ga( @optimise_trackplacementmean, ...
    28, ... % num constraints
    [],[],[],[], ...
    config_optimdrivebounds_onlysum(0, gauss), ...
    config_optimdrivebounds_onlysum(1, gauss), ...
    [], ...
    [14,15,16,17,18,19,20,21,26,27,28], ... % int constraints
    options );

savefig('results/cfg_trkplace_sum.fig');

save results/cfg_trkplace_sum_onlyconfig.mat cfg_trkplace_sum;

% run the full experiment
sum = run_experiments( ...
    config_optimdrive(cfg_trkplace_sum, 2, estimate_tracks), ...
    'sum' );
save results/cfg_trkplace_sum.mat sum;

%% only contig+gauss cost matrix

cfg_trkplace_contig = ga( @optimise_trackplacementmean, ...
    28, ... % num constraints
    [],[],[],[], ...
    config_optimdrivebounds_onlycontig(0, gauss), ...
    config_optimdrivebounds_onlycontig(1, gauss), ...
    [], ...
    [14,15,16,17,18,19,20,21,26,27,28], ... % int constraints
    options );

savefig('results/cfg_trkplace_contig.fig');

% run the full experiment
contig = run_experiments( ...
    config_optimdrive(cfg_trkplace_contig, 2, estimate_tracks), ...
    'contig' );
save results/cfg_trkplace_contig.mat contig;


%% only evolution+gauss cost matrix

cfg_trkplace_evo = ga( @optimise_trackplacementmean, ...
    28, ... % num constraints
    [],[],[],[], ...
    config_optimdrivebounds_onlyevolution(0, gauss), ...
    config_optimdrivebounds_onlyevolution(1, gauss), ...
    [], ...
    [14,15,16,17,18,19,20,21,26,27,28], ... % int constraints
    options );

savefig('results/optimise_trackplacement_evogauss.fig');

% run the full experiment
evo = run_experiments( ...
    config_optimdrive(cfg_trkplace_evo, 2, estimate_tracks), ...
    'evolution' );

save results/cfg_trkplace_evo.mat evo;

%% only sym+gauss cost matrix

cfg_trkplace_sym = ga( @optimise_trackplacementmean, ...
    28, ... % num constraints
    [],[],[],[], ...
    config_optimdrivebounds_onlysym(0, gauss), ...
    config_optimdrivebounds_onlysym(1, gauss), ...
    [], ...
    [14,15,16,17,18,19,20,21,26,27,28], ... % int constraints
    options );

savefig('results/optimise_trackplacement_sym.fig');

% run the full experiment
sym = run_experiments( ...
    config_optimdrive(cfg_trkplace_sym, 2, estimate_tracks), ...
    'sym' );

save results/cfg_trkplace_sym.mat sym;

%% run a totally random one for comparison

random_run = run_experiments( ...
    config_optimdrive(config_optimdrivebounds_randomstart, 2, estimate_tracks), ...
    'totally random');

save results/cfg_random.mat random_run;
