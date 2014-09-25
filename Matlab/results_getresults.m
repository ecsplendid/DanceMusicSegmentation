
c_mean = config_getbest(2,0);
c_mean.compute_confs = 1;

ag_mean = run_experiments( c_mean, ...
    'best mean with optimized track estimates, nov, naive and us', ...
    config_getdefaultsegcalculation, ...
    config_getbestnoveltyconfig, 1 )

save( sprintf( 'results/agres_all-mean-mix_%s.mat', date), 'ag_mean' );

c_med = config_getbestmedian(2,0);
c_med.compute_confs = 1;

agh = run_experiments( c_med, ...
    'best median with optimized track estimates, nov, naive and us', ...
    config_getdefaultsegcalculation, ...
    config_getbestnoveltyconfig, 1 );

save( sprintf( 'results/agres_all-heur-mix_%s.mat', date), 'agh' );


