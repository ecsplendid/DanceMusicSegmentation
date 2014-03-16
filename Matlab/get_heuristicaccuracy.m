function [pheuristicaccuracy] = get_heuristicaccuracy(indexes_timespace, predictions_timespace)
% when the tracks are out of alignment, the mean measurement will not
% clearly demonstrate performance. Here we do an alignment before taking
% the absolute difference.

    pheuristicaccuracy = nan( length( indexes_timespace ), 1 );

    for i=1:length( indexes_timespace )

       this_index = indexes_timespace(i);

       [id] = sort( abs( this_index - predictions_timespace ), 'ascend' );

      % find the closest index
      pheuristicaccuracy(i) = id(1);
    end

    pheuristicaccuracy = mean(pheuristicaccuracy);

end