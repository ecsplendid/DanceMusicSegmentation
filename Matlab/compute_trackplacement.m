function results = compute_trackplacement( ...
    config, show, results  ) 

    % compute the placement of the tracks and evaulate our performance
    [~, best_begin] = find_tracks( length(show.indexes)+1, show.CostMatrix );

    results.predictions = best_begin( 2:end );
    results.predictions_timespace = show.space( results.predictions );

    % we shift the solutions in time space
    results.predictions_timespace = results.predictions_timespace + ...
        config.solution_shift;

    results.matched_tracks = evaluate_performance( ...
                        show.indexes, results.predictions_timespace);
    results.avg_shift = median((results.predictions_timespace-show.indexes'));
    
    results.mean_score = mean(abs(results.predictions_timespace - show.indexes'));
    results.heuristic_score = get_heuristicaccuracy( ...
                       show.indexes, results.predictions_timespace );
    
    if( config.drawSimMat==1 )
       
        visualize_costmatrix( show, config, results );
    end
end
