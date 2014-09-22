function run_experimentsbyconfig( fn )
% loads file in /results/%{fn}
% expects a config variable
% runs the experuiments and saves out the aggregated results

    %fn = 'config_heur_contig-gauss_21-Sep-2014.mat';
    c = load(strcat('results/',fn));
    config.compute_confs = 1;
    agr = run_experiments( c.config, fn );
    save( sprintf('results/agres_%s', fn ), 'agr' );

end