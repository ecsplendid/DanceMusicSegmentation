function [score] = optimise_tracknumberestimate( ibev )

    % this function will be driven from ga (genetic algorithm) to find
    % some decent parameters for optimal track number estimation
    
    score = 0;
    
    config = config_optimdrive(ibev)
    
    tic
    for s=1:length( get_allshows() ); 
       
        [ results, show ] = ...
            execute_show(s, config);
        
        score = score + results.mean_score;

        sprintf( 'out by %d: %s', ...
            results.track_estimate_error, ...
            show.showname )
    end
    toc
    
end

