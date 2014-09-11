classdef aggregate_results
    % results for executing a show
    
    properties
        description
        results = [];
        config
        mean_all = [];
        mean_overall
        heuristic_meanoverall
        heuristic_all
        track_estimate_errors = [];
        track_estimate_errors_avg
        shifts = [];
        shifts_avg
        track_indexconfidences_sum
        track_placementconfidence_sum
        track_placementconfidenceavg_all
        mean_indexplacementconfidence_all
        track_placementconfidenceavg_mean
        mean_indexplacementconfidence_mean
        execution_time
    end
end     