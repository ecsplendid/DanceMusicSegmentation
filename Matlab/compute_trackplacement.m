function results = compute_trackplacement( ...
    config, show, results, num_tracks  ) 

    if nargin < 4
        num_tracks = length(show.indexes)+1;
    end

    % compute the placement of the tracks and evaulate our performance
    [~, best_begin] = find_tracks( ...
        num_tracks, show.CostMatrix );

    results.predictions = best_begin( 2:end );
    results.predictions_timespace = show.space( results.predictions );

    % they might not be if num_tracks was passed in
    if length(results.predictions) == length(show.indexes)
    
        % we shift the solutions in time space
        results.predictions_timespace = results.predictions_timespace + ...
            config.solution_shift;

        results.matched_tracks = evaluate_performance( ...
                            show.indexes, results.predictions_timespace);

        results.shifts = (results.predictions_timespace-show.indexes');

        results.mean_score = mean(abs(results.shifts));

        results.heuristic_score = get_heuristicaccuracy( ...
                           show.indexes, results.predictions_timespace );

    end
end
