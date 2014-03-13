function draw_indexes( space_lim, indexes )

    hold on
   
    drawn_already = zeros(size(indexes,1));
    
    for i=1:size(indexes,1)
        for x=1:size(indexes,2)
        
            col = 'w-';
            
            if x==2, col='b-'; end;
            if x==3, col='w-'; end;
            if x==4, col='g-'; end;
            
            if( drawn_already(i) ~=indexes(i,x)  )
                
                plot( indexes(i,x), indexes(i,x), '+w','LineWidth',2);
                drawn_already(i) = indexes(i,x);
            
            end
            
            if( x==1 ) 
               % text(indexes(i,x),indexes(i,x),sprintf('T%d',i+1),... 
               %     'HorizontalAlignment','left','FontSize',12,'FontWeight','bold', ...
                %    'BackgroundColor','white' );
 
            end
        end
    end
    hold off;
end

