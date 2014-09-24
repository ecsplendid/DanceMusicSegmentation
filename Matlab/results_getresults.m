
novconf = genetic_findbestnoveltyparameters();

ag = run_experiments( config_getbest(2,0), ...
    'best mean with optimized track estimates, nov, naive and us', ...
    config_getdefaultsegcalculation, ...
    novconf );

save( 'results/agres_all-mega-mix_24-Sep-2014.mat', 'ag' );

