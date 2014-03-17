function [SC] = getcost_contig(...
    C, W, min_w, threshold, ...
    costcontig_incentivebalance) 
%%
T = size(C,1);

SC = inf( T, W );
SC_incentive = inf( T, W );
SC_disincentive = inf( T, W );

tic;
for w=min_w:W
    for t=1:T-w+1

        % we have the triangle
        C_square = C( t:t+w-1, t:t+w-1 );
        C_line = getmatrix_indiagonals(C_square);
        
        % we are looking for adjacent blues and reds
        % on the diags away from center
        
        incentive_score = 0;
        disincentive_score = 0;
        
        for i=2:length( C_line )
           
            le = C_line(i-1);
            ri = C_line(i);
            
            avg = (le+ri)/2;
            
            if( le < threshold && ri < threshold)
               incentive_score =  incentive_score + (1-avg) ;
            end
            
            if( le > threshold && ri > threshold)
               disincentive_score =  disincentive_score + avg ;
            end
        end
        
        SC_incentive(t, w) = incentive_score;
        SC_disincentive(t, w) = disincentive_score;
    end
    
    %imagesc(SC);
   % colorbar;
   % drawnow;
end
toc;


SC = -(SC_incentive.*costcontig_incentivebalance + ...
    -SC_disincentive.*(1-costcontig_incentivebalance));

SC = normalize_costmatrix(SC);

SC = SC-costcontig_incentivebalance;

SC(:,1:min_w )=inf;




end