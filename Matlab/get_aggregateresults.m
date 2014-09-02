function [agg_results] = get_aggregateresults( results, config )

    agg_results = aggregate_results();
    
    agg_results.config = config;
    
    assert(~isempty(results));

    width = size(results{1}.track_placementconfidence,1);
    
    agg_results.track_placementconfidence_sum = ...
        zeros( width, 1 );
    agg_results.track_indexconfidences_sum = ...
        zeros( width, 1 );
    
    for i=1:length(results)
        r = results{i};
        
        agg_results.mean_all = [agg_results.mean_all r.mean_score];
        agg_results.heuristic_all = ...
            [agg_results.heuristic_all r.heuristic_score];
        agg_results.shifts = [agg_results.shifts r.shifts];
        agg_results.track_estimate_errors = ...
            [agg_results.track_estimate_errors r.track_estimate_error];
        agg_results.results = [agg_results.results r];
        
        agg_results.track_placementconfidenceavg_all = ...
            [agg_results.track_placementconfidenceavg_all ...
                r.track_placementconfidenceavg];
            
        agg_results.mean_indexplacementconfidence_all = ...
            [agg_results.mean_indexplacementconfidence_all ...
                r.mean_indexplacementconfidence ];  
        
        agg_results.track_placementconfidence_sum = ...
            agg_results.track_placementconfidence_sum + r.track_placementconfidence;
       
        agg_results.track_indexconfidences_sum = ...
            agg_results.track_indexconfidences_sum + r.track_indexconfidences;

    end
    
    agg_results.track_placementconfidenceavg_mean = ...
        mean(agg_results.track_placementconfidenceavg_all);
    agg_results.mean_indexplacementconfidence_mean = ...
        mean(agg_results.mean_indexplacementconfidence_all);
    
    
    agg_results.mean_overall = mean(agg_results.mean_all);
    agg_results.heuristic_meanoverall = mean(agg_results.heuristic_all);
    agg_results.shifts_avg = mean(agg_results.shifts);
    agg_results.track_estimate_errors_avg = ...
        mean(agg_results.track_estimate_errors);
    
end