function [predictions_timespace, matched_tracks, avg_shift] = ...
    compute_trackplacement( ...
    SC, space, indexes, config ) 

    [~, best_begin] = find_tracks( length(indexes)+1, SC );

    predictions = best_begin( 2:end );

    predictions_timespace = space( predictions );

    % we shift the solutions in TIME space
    predictions_timespace = predictions_timespace + config.solution_shift;

    [matched_tracks] = evaluate_performance(indexes, predictions_timespace);

    avg_shift = median((predictions_timespace-indexes'));
    
end
