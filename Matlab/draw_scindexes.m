function draw_scindexes( indexes )

    hold on
   
    for x=2:size(indexes,1)
    
        plot( indexes(x)-indexes(x-1), indexes(x), '+w','LineWidth',2);

    end
    hold off;
end

