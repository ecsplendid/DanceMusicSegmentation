function draw_rectangles( indexes, color )
%DRAW_RECTANGLES Summary of this function goes here
%   Detailed explanation goes here

hold on


for i=1:length(indexes)-1
   
    plot( indexes( [ i, i+1, i+1, i, i ] ), indexes([ i, i, i+1, i+1,i ]), ...
        strcat(':',color),'LineWidth',3 );
    
end

hold off


end

