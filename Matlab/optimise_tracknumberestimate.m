function [score] = optimise_tracknumberestimate( ibev )

    % this function will be driven from ga (genetic algorithm) to find
    % some decent parameters for optimal track number estimation
    
    score = 0;
    
    % ibev = config_optimdrivebounds_randomstart;
    config = config_optimdrive(ibev);
    
    tic
    for s=1:length( get_allshows() ); 
       
        [ ~, ~,  ~, ~, ~, track_estimate, indexes, showname ] = ...
            execute_show(s, config);
        
        this_score = abs(track_estimate - (length(indexes)+1));
        
        score = score + this_score;

        sprintf( 'out by %d: %s...', this_score, showname );

    end
    toc
    
 
end