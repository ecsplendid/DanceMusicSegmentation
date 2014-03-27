function [predictions_timespace, matched_tracks, avg_shift] = compute_trackplacement( ...
        showname, SC, drawSimMat, space, ...
        indexes, solution_shift, tileWidthSecs, C, w, secondsPerTile, ...
        use_costsymmetrysum, use_costsymmetrydiff, use_costsymmetry, ...
            use_costcontigpast, use_costcontigfuture, use_costsum, use_costgaussian, ...
            costsymmetrysum_incentivebalance, costsymmetry_incentivebalance, ...
            costcontigfuture_incentivebalance, costcontigpast_incentivebalance, ...
            costsymmetrydiff_incentivebalance, costsum_incentivebalance, ...
            costgauss_incentivebalance, contig_windowsize ) 

    [~, best_begin] = find_tracks( length(indexes)+1, SC );

    [T, ~] = size(C);
    
    predictions = best_begin( 2:end );
    
    indexes_tilespace = indexes ./ tileWidthSecs;

    predictions_timespace = space( predictions );
    
    % we shift the solutions in TIME space
    predictions_timespace = predictions_timespace + solution_shift;
    predictions = predictions + (solution_shift/tileWidthSecs);
    
    
    [matched_tracks] = evaluate_performance(indexes, predictions_timespace);

    avg_shift = median((predictions_timespace-indexes'));
    
    % draw figures
    if drawSimMat == 1
        figure(1)

       % in time space 
       % imagesc(space,space, sim_mat_fft);daspect([1 1 1]);colorbar;colorbar;axis xy;
       % imagesc(space,space, C);daspect([1 1 1]);colorbar;colorbar;axis xy;

       % in tile space
         imagesc(C);daspect([1 1 1]);colorbar;colorbar;axis xy;
        draw_rectangles( [predictions T .* tileWidthSecs], 'k' );
      
        draw_indexes(space(end)./indexes_tilespace, indexes_tilespace);
        title(sprintf('1-Cosine Matrix\n%s',showname));
        xlabel('Tiles');
        ylabel('Tiles');

        figure( 2 );
         
        pmean = mean(abs(indexes' - predictions_timespace));

        % indexes are in time space
        pheuristicaccuracy = get_heuristicaccuracy( indexes, predictions_timespace );
        
        fprintf( 'mean=%.2f heuristic=%.2f medshift=%.2f\n\n', ...
            pmean, pheuristicaccuracy, avg_shift  );
        mean(matched_tracks)

        
        imagesc(SC);
        title(sprintf('Cost Matrix @ T=%.2fs [SS:%.1f@i%.1f SD:%.1f@i%.1f SY:%.1f@i%.1f CP:%.1f@i%.1f CF:%.1f@i%.1f SU:%.1f@i%.1f GA:%.1f@i%.1f] CONT%d \n%s\nmean=%.1f heuristic=%.1f meandiff=%.1f shift=%.1f\nWhite=ACTUAL Black=PREDICTED',...
           secondsPerTile,  ...
            use_costsymmetrysum, costsymmetrysum_incentivebalance, ...
            use_costsymmetrydiff, costsymmetrydiff_incentivebalance, ...
            use_costsymmetry, costsymmetry_incentivebalance, ...
            use_costcontigpast, costcontigpast_incentivebalance, ...
            use_costcontigfuture, costcontigfuture_incentivebalance, ...
            use_costsum, costsum_incentivebalance, ...
            use_costgaussian, costgauss_incentivebalance, ...
            contig_windowsize, ...
           showname, pmean, pheuristicaccuracy, avg_shift, solution_shift ));
        xlabel('Tiles');
        ylabel('Tiles');
        colorbar;
        draw_scindexes(predictions, indexes_tilespace, w, T);
      
       % figure(3)
       % hist(predictions_timespace-indexes',50);
       % title('shift histogram')

    end

end
