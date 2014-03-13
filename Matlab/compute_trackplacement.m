function [predictions, matched_tracks] = compute_trackplacement( ...
        showname, SC, drawSimMat, space, ...
        indexes, solution_shift, tileWidthSecs, C  ) 

    [~, best_begin] = find_tracks( length(indexes)+1, SC );

    [T, ~] = size(C);
    
    best_begin_tilespace = best_begin;
    indexes_tilespace = indexes ./ tileWidthSecs;

    best_begintiles = best_begin';
    best_begin = space( best_begin );
    predictions = best_begin(2:end);

    predictions = predictions + solution_shift;

    [matched_tracks] = evaluate_performance(indexes, best_begin(2:end));

    % draw figures
    if drawSimMat == 1
        figure(1)

       % in time space 
       % imagesc(space,space, sim_mat_fft);daspect([1 1 1]);colorbar;colorbar;axis xy;
       % imagesc(space,space, C);daspect([1 1 1]);colorbar;colorbar;axis xy;

       % in tile space
         imagesc(C);daspect([1 1 1]);colorbar;colorbar;axis xy;
        draw_rectangles( [best_begin_tilespace T .* tileWidthSecs], 'k' );
      
        draw_indexes(space(end)./indexes_tilespace, indexes_tilespace);
        title(sprintf('1-Cosine Matrix\n%s',showname));
        xlabel('Tiles');
        ylabel('Tiles');

        figure(2)
         
        imagesc(SC);
        title(sprintf('Cost Matrix\n%s',showname));
         xlabel('Tiles');
        ylabel('Tiles');
        draw_scindexes(best_begintiles);


    end

end