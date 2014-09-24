
novconf = genetic_findbestnoveltyparameters;

c = config_getbest(2);

c.drawSimMat = 0;
c.compute_confs = 1;
c.dataset = 2;

ag = run_experiments( c, ...
    'best mean with optimized track estimates, nov, naive and us', ...
    config_getdefaultsegcalculation, ...
    novconf );

save( 'results/agres_all-mega-mean_24-Sep-2014.mat', 'ag' );


c.dataset = 3;
ag_linkmik = run_experiments( c, ...
    'LINDMIK best mean with optimized track estimates, nov, naive and us', ...
    config_getdefaultsegcalculation, ...
    novconf );

save( 'results/agres_all-lindmik-mega-mean_24-Sep-2014.mat', 'ag_linkmik' );
