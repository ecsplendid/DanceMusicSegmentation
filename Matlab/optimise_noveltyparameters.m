function [score] = optimise_noveltyparameters( ibev, test_mode )
%optimise_noveltyparameters find the best parameters for the novelty
%function
% learn these 
% 1,novelty_minpeakradius = 10..150 INT
% 2,novelty_threshold = 0.01..1
% 3,novelty_kernelsize = 30..300 INT
% 4,secondsPerTile = 3..40 INT
% 5,bandwidth = 1..15 INT
% 6,cosine_normalization 0.4..1.5
% 7,lpf 800..1950 INT
% 8,hpf 50..500 INT
% 9,solution shift -5..5 INT

if nargin > 0
    ibev = [ 40, 0.3, 120, 20, 5, 0.9, 1400, 50, 0 ];
end

    config = config_getbest(1);
    
    config.novelty_minpeakradius = (ibev(1));
    config.novelty_threshold = ibev(2);
    config.novelty_kernelsize = (ibev(3));
    config.secondsPerTile = (ibev(4));
    config.bandwidth = (ibev(5));
    config.cosine_normalization = (ibev(6));
    config.lowPassFilter = (ibev(7));
    config.highPassFilter = (ibev(8));
    config.novelty_solutionshift = (ibev(9));
    config.memory_efficient = 1;
    config.estimate_tracks = 0;
    config.drawSimMat = 0;
    
shows = get_allshows(config);

scores = nan(length(shows), 1);

parfor s=1:length(shows)
    
    show = get_show(s, config); 
    show = get_cosinematrix( show, config );
    
      % novelty predictions
    trackestimate_novelty = ...
        get_noveltyfunction( ...
            show, config, ...
            config.novelty_kernelsize, ...
            config.novelty_minpeakradius, ...
            config.novelty_threshold, ...
            config.drawSimMat );
        
    % novelty track error
    scores(s, 1) = ...
        (length( show.indexes ) + 1) ...
        - (length( trackestimate_novelty ) + 1);
end
 
    
score = sum(scores);

end