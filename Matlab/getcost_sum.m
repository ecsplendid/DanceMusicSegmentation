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
        
        score = 0;
        
        element_count = size( C_square, 1 )^2;

        low_cost = C_square(C_square<0);
        high_cost = C_square(C_square>=0);

        if( ~isempty(low_cost) )

            new_score = (abs(sum( low_cost )));
            new_score = new_score / element_count;
            new_score = new_score * costsum_incentivebalance;

            score = score - new_score;
        end

        if( ~isempty(high_cost) )

            new_score =  (sum( high_cost ));
            new_score = new_score / element_count;
            new_score = new_score * (1-costsum_incentivebalance);

            score = score + new_score;
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

 
 

