function [predictions_timespace, matched_tracks] = compute_trackplacement( ...
        showname, SC, drawSimMat, space, ...
        indexes, solution_shift, tileWidthSecs, C, w  ) 

    [~, best_begin] = find_tracks( length(indexes)+1, SC );

    [T, ~] = size(C);
    
    predictions = best_begin(2:end);
    predictions = predictions + solution_shift;
    
    indexes_tilespace = indexes ./ tileWidthSecs;

    predictions_timespace = space( predictions );
    
    [matched_tracks] = evaluate_performance(indexes, predictions_timespace);

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

        figure(2)
         
        pmean = mean(abs(indexes' - predictions_timespace));
        pmedian = median(abs(indexes' - predictions_timespace));
        
        fprintf( 'mean=%.2f median=%.2f', pmean, pmedian  );
        
        imagesc(SC);
        title(sprintf('Cost Matrix\n%s\nWhite=ACTUAL Black=PREDICTED\nmean=%.2f median=%.2f',...
            showname, pmean, pmedian ));
        xlabel('Tiles');
        ylabel('Tiles');
        colorbar;
        draw_scindexes(predictions, indexes_tilespace, w, T);
      


    end

end