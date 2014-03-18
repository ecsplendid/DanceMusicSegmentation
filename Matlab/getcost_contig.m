function [SC] = getcost_contig(...
    C, W, min_w, ...
    costcontig_incentivebalance) 
%%
T = size(C,1);
SC = inf( T, W );
gwin = gausswin( W ) ;

high_thresh = 0.1;
low_thresh = -0.4;

tic;
for w=min_w:W
    for t=1:T-w+1

        % we have the triangle
        C_square = C( t:t+w-1, t:t+w-1 );
        C_line = getmatrix_indiagonals(C_square);
        
        % we are looking for adjacent blues and reds
        % on the diags away from center
        
        score = 0;
       
        for i=(W+1):length( C_line )
           
            le = C_line(i-1);
            ri = C_line(i);
            
            mx = max(le, ri);
            
            if( le < low_thresh && ri < low_thresh)
               newscore = ((1-mx)/i) * costcontig_incentivebalance;
               score = score - (gwin(w) * newscore);
            end
            
            if(  le > high_thresh && ri > high_thresh )
               score =  score + (mx/i) * (1-costcontig_incentivebalance);
            end
        end
        
        SC(t, w) = score;
 
    end
    
    %imagesc(SC);
    % colorbar;
    % drawnow;
end
toc;

SC = normalize_costmatrix(SC);

SC(:,1:min_w )=inf;




end