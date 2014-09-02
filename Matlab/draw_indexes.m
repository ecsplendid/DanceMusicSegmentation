function draw_indexes( indexes )

    hold on
   
    for i=1:size(indexes,1)
        
        plot( indexes(i), indexes(i), '+w','LineWidth',2);
    end
    hold off;
end

