function config_geneticsearch( optimization, execute_full, gauss )
% config_geneticsearch execute all the experiments i.e. find optimal
% parameters and run experiments
% optimization==0, mean
% optimization==1, heuristic
% optimization==2, heauristic+mean
% optimization==3, track number estimate

optimization_fn = @optimise_trackplacementmean;
desc = 'mean_';

if nargin > 0
    if optimization == 1
        optimization_fn = @optimise_trackplacementheuristic;
        desc = 'heur_';
    elseif optimization == 2
        optimization_fn = @optimise_trackplacementheuristicandmean;
        desc = 'mean-heur_';
    elseif optimization == 3
        optimization_fn = @optimise_tracknumberestimate;
        desc = 'trackes_';
    end
end

if nargin < 2
    execute_full = 0;
end

if nargin < 3
    gauss = 1;
end

gaussdesc = '';
if gauss
   gaussdesc ='-gauss';
end

%% everything (don't run this twice on gauss /in {0,1} )
execute_geneticsearch( ...
    sprintf( '%sall', desc ), optimization_fn, ...
    @config_optimdrivebounds, ...
    gauss, execute_full );

%% only sym+gauss cost matrix
execute_geneticsearch( ...
    sprintf('%ssym%s',desc, gaussdesc), optimization_fn, ...
    @config_optimdrivebounds_onlysym, ...
    gauss, execute_full );

%% only contig+gauss cost matrix
execute_geneticsearch( ...
    sprintf('%scontig%s',desc, gaussdesc), optimization_fn, ...
    @config_optimdrivebounds_onlycontig, ...
    gauss, execute_full );

%% only sum+gauss cost matrix
execute_geneticsearch( ...
    sprintf('%ssum%s',desc, gaussdesc), optimization_fn, ...
    @config_optimdrivebounds_onlysum, ...
    gauss, execute_full );

%% only evolution+gauss cost matrix
execute_geneticsearch( ...
    sprintf('%sevo%s',desc, gaussdesc), optimization_fn, ...
    @config_optimdrivebounds_onlyevolution, ...
    gauss, execute_full );


%% run a totally random one for comparison
if execute_full

    random_run = run_experiments( ...
        config_optimdrive(config_optimdrivebounds_randomstart, 2, estimate_tracks), ...
        'totally random' );
    save( sprintf( 'results/cfg_random_%s.mat', date ), random_run );
end

end