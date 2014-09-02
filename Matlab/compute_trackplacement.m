function [heuristic_score, mean_score, predictions_timespace, ...
    predictions, ...
    matched_tracks, avg_shift] = compute_trackplacement( ...
    SC, space, indexes, config, showname, T, C2, tileWidthSecs ) 

    % compute the placement of the tracks and evaulate our performance

    [~, best_begin] = find_tracks( length(indexes)+1, SC );

    predictions = best_begin( 2:end );

    predictions_timespace = space( predictions );

    % we shift the solutions in time space
    predictions_timespace = predictions_timespace + config.solution_shift;

    [matched_tracks] = evaluate_performance( ...
                        indexes, predictions_timespace);
    avg_shift = median((predictions_timespace-indexes'));
    
    mean_score = mean(abs(predictions_timespace - indexes'));
    heuristic_score = get_heuristicaccuracy( ...
                        indexes, predictions_timespace );
    
    if( config.drawSimMat==1 )
       
        visualize_costmatrix( ...
            T, config, showname, indexes, predictions, ...
            space, SC, ...
            mean_score, heuristic_score, avg_shift, C2, ...
            tileWidthSecs );
        
    end
    
    
end
