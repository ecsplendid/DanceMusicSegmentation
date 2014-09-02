function [score] = optimise_trackplacement( ibev )

    % this function will be driven from ga (genetic algorithm) to find
    % some decent parameters for optimal track placement performance
    
    score = 0;
    
    % ibev = config_optimdrivebounds_randomstart;
    config = config_optimdrive(ibev);
    
    tic
    for s=1:length( get_allshows() ); 
       
        [ ~, ~,  ~, mean_score, ~, ~ ] = execute_show(s, config);
        
        score = score + mean_score;

        sprintf( '%d: %s...', this_score, showname )

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