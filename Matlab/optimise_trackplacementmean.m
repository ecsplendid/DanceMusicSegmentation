function [score] = optimise_trackplacementmean( ibev )

    % assumes the existence of test_shows global variable
    % this function will be driven from ga (genetic algorithm) to find
    % some decent parameters for optimal track placement performance
    
    % ibev = config_optimdrivebounds_randomstart;
    config = config_optimdrive( ibev );
    agresults = run_experiments( config );
    score = agresults.mean_overall;
    
end