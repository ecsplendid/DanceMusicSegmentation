function draw_scindexes( predictions, indexes_tilespace, w, T )

    hold on

    inds_withone = [1; indexes_tilespace; T];
    preds_withone = [1 predictions T];
   
    for x=2:size(preds_withone,2)-1
    
        plot( (preds_withone(x+1)-preds_withone(x)), preds_withone(x), '+k','LineWidth',2);
        plot( (inds_withone(x+1)-inds_withone(x)), inds_withone(x), '+w','LineWidth',2);
        
    end
    hold off;
end

