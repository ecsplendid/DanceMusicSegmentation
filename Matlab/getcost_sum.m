function [ SC ] = getcost_sum( C, W, min_w, ...
    costsum_incentivebalance )
%   BUILD_SONGCOSTMATRIX Summary of this function goes here
%   type is default 'area', or 'symetry'
%   C is cost matrix
%   T is total time in seconds
%   W is the largest song width
%   uses dynamic programming to get it fast

T = size(C,1);
SC = inf( T, W );

for w=min_w:W
    for t=1:T-w+1

        % we have the triangle
        C_square = C( t:t+w-1, t:t+w-1 );
        C_dags = getmatrix_indiagonals(C_square, 1);
        
        score = 0;
        
        for i=2:size(C_square,1)
            
            element_count = size( C_dags, 1 )-i+1;
            
            dag = C_dags( i, 1:element_count );
            
            low_cost = dag(dag<0);
            high_cost = dag(dag>=0);
            
            if( ~isempty(low_cost) )
                
                new_score = (abs(sum( low_cost ))/element_count);
                score = score - (new_score * costsum_incentivebalance);
            end
            
            if( ~isempty(high_cost) )
                
                new_score =  (sum( high_cost )/element_count);
                score = score + new_score * (1-costsum_incentivebalance);
            end
        end
        
        SC(t, w) = score;
        
    end
    
   %imagesc(SC);
   % colorbar;
   % drawnow;
end


SC = normalize_byincentivebias(SC, costsum_incentivebalance);

SC(:,1:min_w )=inf;
    
end

 
 

