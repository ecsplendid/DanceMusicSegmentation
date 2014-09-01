function [score] = optimise_function( ibev )

    % this function will be driven from ga (genetic algorithm) to find
    % some decent parameters
    
    which_shows = 1:3;%length(shows);
    
    score = 0;
    
   % ibev = config_optimdrivebounds_randomstart;
    config = config_optimdrive(ibev);
    
    config
    
    tic
    for s=1:length(which_shows); 
       
    [indexes, audio_low, showname] = get_show(s, config.sampleRate);
    
    [C, W, ~, space, T, w] = get_cosinematrix(...
        audio_low, config );
    
    clear audio_low;
        
    C2 = C.^config.cosine_normalization;

    % we do the normalization manually to keep it centered
    C2 = (C2.*2)-1; 
    
    CN = getcost_sum3( T, C2, W, w, ...
             config.costsum_incentivebalance ...
            ) .* config.use_costsum;  
        
    CS = getcost_symmetry3( T, C2, W, w, ...
         config.costsymmetry_incentivebalance ...
        ) .* config.use_costsymmetry;  
    
    CDG = getcost_contigdiag1( T, C2, W, w, ...
         config.costevolution_incentivebalance ...
        ) .* config.use_costcontigevolution;  

    SCS = getcost_contigstatic( ...
        T, C2, W, w, ...
         config.costcontigpast_incentivebalance, config.contig_windowsize, 0 ... 
        ) .* config.use_costcontigpast;  
    
    SCSF = getcost_contigstatic( ...
        T, C2, W, w, ...
         config.costcontigfuture_incentivebalance, config.contig_windowsize, 1 ...
        ) .* config.use_costcontigfuture; 
    
    SCG = getcost_gaussian( T, W, w, ...
         1, config.costgauss_incentivebalance ) ...
        .* config.use_costgaussian;
    
    SCF = CN+CS+CDG+SCS+SCSF+SCG;
    
    %[howmanytracks_predicted] = ...
     %   estimate_numbertracks( 1, SCF, showname, indexes );
    
    [predictions_timespace, ~, ~] = ...
        compute_trackplacement( ...
             SCF, space, indexes, config );
    
    this_score = mean(abs(predictions_timespace - indexes'));
    score = score + this_score;
    
    sprintf( '%d: %s...', this_score, showname );
    
    % early break out heuristic, if any individial show score > 18
    % let's sack it off and let the optimization routine move on
    
    if this_score > 18
       
       % half way house (premature) average
       score = score / s;
       return; 
    end
    
    end
    toc
    
    % average it
    score = score / length(which_shows);
    
end