

ag = run_experiments( config_getbest(2), ...
    'best mean with best track es', ...
    config_getdefaultsegcalculation );

save( 'results/agres_all-mean_23-Sep-2014.mat', 'ag' );

results_drawfpcurves(ag)