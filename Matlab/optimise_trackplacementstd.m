function [score] = optimise_trackplacementstd( ibev )

    % this function will be driven from ga (genetic algorithm) to find
    % some decent parameters for optimal track placement performance
    %this one uses standard deviation of the shifts
    
    score = 0;
    
    % ibev = config_optimdrivebounds_randomstart;
    config = config_optimdrive(ibev);
    
    agresults = run_experiments( config );
   
    score = std(agresults.shifts);
   
end