function [score] = optimise_tracknumberestimate( ibev )

    % this function will be driven from ga (genetic algorithm) to find
    % some decent parameters for optimal track number estimation

    estimate_tracks = 1;
    dataset = 1;
    
    config = config_optimdrive(ibev, dataset, estimate_tracks);

    agresults = run_experiments( config );

    score = agresults.convexity_estimate;

end

