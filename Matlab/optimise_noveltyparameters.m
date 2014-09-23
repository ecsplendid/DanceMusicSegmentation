function [score] = optimise_noveltyparameters( ibev )
%optimise_noveltyparameters find the best parameters for the novelty
%function
% learn these three
% 1,novelty_minpeakradius = 50
% 2,novelty_threshold = 0.3
% 3,novelty_kernelsize = 120

    config = config_getbest(1);
    config.novelty_minpeakradius = ibev(1);
    config.novelty_threshold = ibev(2);
    config.novelty_kernelsize = ibev(3);
    
    agresults = run_experiments( config );
    
    score = agresults.trackestimate_noveltyerrorsavg;
end