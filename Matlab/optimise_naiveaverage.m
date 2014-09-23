function [score] = optimise_naiveaverage( ibev )
%optimise_naiveaverage find the best config.trackestimate_naiveaverage
%parameter
   
    config = config_getdefault;
    config.trackestimate_naiveaverage = ibev;
    
    agresults = run_experiments( config );
    
    score = agresults.trackestimate_naiveerrorsavg;
    
end