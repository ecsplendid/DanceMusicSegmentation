function [score] = optimise_naiveaverage( ibev )

   
    config = config_getdefault;
    config.trackestimate_naiveaverage = ibev;
    
    agresults = run_experiments( config );
    
    score = agresults.trackestimate_naiveerrorsavg;
    
end