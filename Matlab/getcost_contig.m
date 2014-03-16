function [SC] = getcost_contig(C, W, min_w, threshold, contig_normalization) 
%%
T = size(C,1);

SC = inf( T, W );

tic;
for w=min_w:W
    for t=1:T-w+1

        % we have the triangle
        C_square = C( t:t+w-1, t:t+w-1 );
        C_line = getmatrix_indiagonals(C_square);
        
        % we are looking for adjacent blues and reds
        % on the diags away from center
        
        score = 0;
        
        for i=2:length( C_line )
           
            le = C_line(i-1);
            ri = C_line(i);
            
            avg = (le+ri)/2;
            
            if( le < threshold && ri < threshold)
               score =  score + (1-avg); 
            end
            
            if( le > threshold && ri > threshold)
               score =  score - avg;
            end
        end
        
        score = -(score/ w^0.9 );
        SC( t, w ) = score;

    end
    
    %imagesc(SC);
   % colorbar;
   % drawnow;
end
toc;

SC(:,1:min_w )=inf;
SC = normalize_costmatrix(SC);



end