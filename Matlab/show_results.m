classdef show_results
    % results for executing a show
    
    properties
       convexity_estimate
    	config
        show
        posterior
        predictions
        predictions_timespace
        matched_tracks
        shifts
        avg_shift
        mean_score
        heuristic_score
        track_estimate
        track_estimate_error
        track_placementconfidenceavg
        track_indexconfidences
        mean_indexplacementconfidence
        worst_indexplacementconfidence
        track_placementconfidence
        execution_time
        naive_trackestimate
        naive_track_estimate_error
    end
    
    methods
        function vis(results, fig_num)
            if( nargin > 1 )
                visualize_costmatrix( results, fig_num )
            else
                visualize_costmatrix( results );
            end
           
        end
    end
end     
