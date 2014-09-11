function [score] = optimise_trackplacementheuristic( ibev )

    % this function will be driven from ga (genetic algorithm) to find
    % some decent parameters for optimal track placement performance
    
    % ibev = config_optimdrivebounds_randomstart;
    config = config_optimdrive(ibev);
    
    agresults = run_experiments( config );
   
    score = agresults.heuristic_meanoverall;
   
end