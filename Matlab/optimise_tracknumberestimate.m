function [score] = optimise_tracknumberestimate( ibev )

    % this function will be driven from ga (genetic algorithm) to find
    % some decent parameters for optimal track number estimation
    
    config = config_optimdrive(ibev)
    
	agresults = run_experiments( config );
   
    score = agresults.track_estimate_errors_avg;
    
end

