function results = compute_trackplacement( ...
    config, show, results, num_tracks  ) 

    if nargin < 4
        num_tracks = length(show.indexes)+1;
    end

    % compute the placement of the tracks and evaulate our performance
    [~, best_begin] = find_tracks( ...
        num_tracks, show.CostMatrix );

    results.predictions_tilespace = best_begin( 2:end );
    
    % now in TIME space by default
    results.predictions = show.space(results.predictions_tilespace);

    % they might not be if num_tracks was passed in
    if length(results.predictions) == length(show.indexes)
    
        % we shift the solutions in time space
        results.predictions = results.predictions + ...
            config.solution_shift;

        results.matched_tracks = evaluate_performance( ...
                            show.indexes, results.predictions);

        results.residuals_ourmethod = (results.predictions-show.indexes');

        results.mean_score = mean(abs(results.residuals_ourmethod));

        results.heuristic_score = get_heuristicaccuracy( ...
                           show.indexes, results.predictions );

    end
end
