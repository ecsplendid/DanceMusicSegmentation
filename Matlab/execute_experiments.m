function execute_experiments
% run all the basic experiments from the best configs
% for mixture, sum, evo, contig, sym.
% no track estimation or posteior

% sums first
c = load('config/mean/config_sum-gauss_22-Sep-2014.mat');
c.config.compute_confs = 1;
agr3 = run_experiments( c.config, config_getdefaultsegcalculation, ...
    config_getbestnoveltyconfig, 1 )
save( sprintf( 'results/agres_mean_sum_%s', date ), 'agr3' );

c = load('config/mean/config_all_mn_21-Sep-2014.mat');
c.config.compute_confs = 1;
agr = run_experiments( c.config, config_getdefaultsegcalculation, ...
    config_getbestnoveltyconfig, 1 )
save( sprintf( 'results/agres_mean_all_%s', date ), 'agr' );

c = load('config/mean/config_contig-gauss_21-Sep-2014.mat');
c.config.compute_confs = 1;
agr1 = run_experiments( c.config, config_getdefaultsegcalculation, ...
    config_getbestnoveltyconfig, 1 )
save( sprintf( 'results/agres_mean_contig_%s', date ), 'agr1' );

c = load('config/mean/config_evo-gauss_22-Sep-2014.mat');
c.config.compute_confs = 1;
agr2 = run_experiments( c.config, config_getdefaultsegcalculation, ...
    config_getbestnoveltyconfig, 1 )
save( sprintf( 'results/agres_mean_evo_%s', date ), 'agr2' );

c = load('config/mean/config_sym-gauss_21-Sep-2014.mat');
c.config.compute_confs = 1;
agr4 = run_experiments( c.config, config_getdefaultsegcalculation, ...
    config_getbestnoveltyconfig, 1 )
save( sprintf( 'results/agres_mean_sym_%s', date ), 'agr4' );

%%

c = load('config/median/best-median.mat');
c.config.compute_confs = 1;
agr5 = run_experiments( c.heur, config_getdefaultsegcalculation, ...
    config_getbestnoveltyconfig, 1 )
save( sprintf( 'results/agres_median_all_%s', date ), 'agr5' );

c = load('config/median/config_heur_contig-gauss_21-Sep-2014.mat');
c.config.compute_confs = 1;
agr6 = run_experiments( c.config, config_getdefaultsegcalculation, ...
    config_getbestnoveltyconfig, 1 )
save( sprintf( 'results/agres_median_contig_%s', date ), 'agr6' );

c = load('config/median/config_heur_evo-gauss_22-Sep-2014.mat');
c.config.compute_confs = 1;
agr7 = run_experiments( c.config, config_getdefaultsegcalculation, ...
    config_getbestnoveltyconfig, 1 )
save( sprintf( 'results/agres_median_evo_%s', date ), 'agr7' );

c = load('config/median/config_heur_sum-gauss_21-Sep-2014.mat');
c.config.compute_confs = 1;
agr8 = run_experiments( c.config, config_getdefaultsegcalculation, ...
    config_getbestnoveltyconfig, 1 )
save( sprintf( 'results/agres_median_sum_%s', date ), 'agr8' );

c = load('config/median/config_heur_sym-gauss_21-Sep-2014.mat');
c.config.compute_confs = 1;
agr9 = run_experiments( c.config, config_getdefaultsegcalculation, ...
    config_getbestnoveltyconfig, 1 )
save( sprintf( 'results/agres_median_sym_%s', date ), 'agr9' );


end