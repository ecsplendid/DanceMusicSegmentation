%% options setup

options = gaoptimset;

options = gaoptimset(options,'PopulationSize', 100);
options = gaoptimset(options,'EliteCount', 15);
options = gaoptimset(options,'Generations', 20);
options = gaoptimset(options,'StallGenLimit', 4);
options = gaoptimset(options,'Display', 'iter');
options = gaoptimset(options,'PlotFcns', {  @gaplotbestf @gaplotbestindiv @gaplotdistance @gaplotexpectation @gaplotgenealogy @gaplotrange @gaplotscorediversity @gaplotscores @gaplotselection @gaplotstopping @gaplotmaxconstr });
options = gaoptimset(options,'Vectorized', 'off');
options = gaoptimset(options,'UseParallel', 1 );

%% mean for finding best optimise_trackplacementmean

cfg_trkplacemean = ga( @optimise_trackplacementmean, ...
    25, ... % num constraints
    [],[],[],[], ...
    config_optimdrivebounds(0), ...
    config_optimdrivebounds(1), ...
    [], ...
    [14,15,16,17,18,19,20,21], ... % int constraints
    options );

savefig('results/optimise_trackplacementmean.fig');

% run the full experiment
ag1 = run_experiments( config_optimdrive(cfg_trkplacemean, 2) );
ag1.description = 'best mean';
save results/cfg_trkplacemean.mat ag1;

%% only sum+gauss cost matrix

gauss = 1;

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


%% only contig+gauss cost matrix

cfg_trkplace_contiggauss = ga( @optimise_trackplacementmean, ...
    25, ... % num constraints
    [],[],[],[], ...
    config_optimdrivebounds_onlycontig(0), ...
    config_optimdrivebounds_onlycontig(1), ...
    [], ...
    [14,15,16,17,18,19,20,21], ... % int constraints
    options );

savefig('results/cfg_trkplace_contiggauss.fig');

% run the full experiment
ag10 = run_experiments( config_optimdrive(cfg_trkplace_contiggauss, 2) );
ag10.description = 'evolution + gauss';
save results/cfg_trkplace_contiggauss.mat ag10;

%% only evolution+gauss cost matrix

cfg_trkplace_evogauss = ga( @optimise_trackplacementmean, ...
    25, ... % num constraints
    [],[],[],[], ...
    config_optimdrivebounds_onlyevolution(0), ...
    config_optimdrivebounds_onlyevolution(1), ...
    [], ...
    [14,15,16,17,18,19,20,21], ... % int constraints
    options );

savefig('results/optimise_trackplacement_evogauss.fig');

% run the full experiment
ag5 = run_experiments( config_optimdrive(cfg_trkplace_evogauss, 2) );
ag5.description = 'evolution + gauss';
save results/cfg_trkplace_evogauss.mat ag5;

%% only sym+gauss cost matrix

cfg_trkplace_symgauss = ga( @optimise_trackplacementmean, ...
    25, ... % num constraints
    [],[],[],[], ...
    config_optimdrivebounds_onlysym(0), ...
    config_optimdrivebounds_onlysym(1), ...
    [], ...
    [14,15,16,17,18,19,20,21], ... % int constraints
    options );

savefig('results/optimise_trackplacement_symgauss.fig');

% run the full experiment
ag11 = run_experiments( config_optimdrive(cfg_trkplace_symgauss, 2) );
ag11.description = 'sym + gauss';
save results/cfg_trkplace_symgauss.mat ag11;

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