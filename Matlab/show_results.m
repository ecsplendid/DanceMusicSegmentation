classdef show_results
    % results for executing a show
    
    properties
        convexity_estimate
        config
        show
        posterior
        predictions
        predictions_tracksnotknown=[]
        predictions_tilespace
        matched_tracks
        shifts
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
        trackestimate_naive
        trackestimate_naiveerror
        trackestimate_noveltyerror
        predictions_novelty
        predictions_noveltytracksknown
        novelty_indexerror
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
