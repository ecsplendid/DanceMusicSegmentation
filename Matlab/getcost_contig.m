function [SC] = getcost_contig(...
    C, W, min_w, ...
    costcontig_incentivebalance) 
%%
T = size(C,1);
SC = inf( T, W );
gwin = gausswin( W ) ;

%%
tic;
for w=min_w:W
    for t=1:T-w+1
%%

        % we have the triangle
        C_square = C( t:t+w-1, t:t+w-1 );
        C_line = getmatrix_indiagonals(C_square);

        red = C_line(C_line>0);
        blue = C_line(C_line<=0);
        
        high_thresh = mean( red );
        low_thresh = -(mean( blue )+0.5);
            
        % we are looking for adjacent blues and reds
        % on the diags away from center
        
        score = 0;
       
        for i=(W+1):length( C_line )
           
            le = C_line(i-1);
            ri = C_line(i);
            
            mix = abs(le)+abs(ri);
            
            if( le < low_thresh && ri < low_thresh)
               newscore = (mix/w);
             %  newscore = newscore * gwin(w);
               newscore = newscore * costcontig_incentivebalance;
               
               score = score - newscore;
            end
            
            if(  le > high_thresh && ri > high_thresh )
               
                newscore = (mix/w);
              %  newscore = newscore * gwin(w);
                newscore = newscore * (1-costcontig_incentivebalance);

                score =  score + newscore;

            end
        end
        
        SC(t, w) = score;
 %%
    end
    
    %imagesc(SC);
    % colorbar;
    % drawnow;
end
toc;

SC = normalize_byincentivebias(SC, costcontig_incentivebalance);

SC(:,1:min_w )=inf;




end