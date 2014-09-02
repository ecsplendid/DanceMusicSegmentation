function [SC] = getcost_sum3( show, config ) 
% getcost_sum3 dynamic programming implementation of getcost_sum2 which
% runs in O(TW)

%%

SC = inf( show.T, show.W );
T = show.T;
W = show.W;
SF = getmatrix_selfsim( show.CosineMatrix, ...
    show.W, 1 );

for t=1:T
    
    score = 0;
    
    for w=1:min(W, t)
        
        vals = SF( t-(w-1), 1:w );
        
        blues = sum(vals( vals<=0 )) * (1-config.costsum_incentivebalance); 
        reds = sum(vals( vals>0 )) * (config.costsum_incentivebalance); 
        
        new_score = (blues + reds);
        
        score = score + new_score;
        
        SC( (t-w)+1, w ) = score / w;
    end
end

SC = normalize_byincentivebias(SC, config.costsum_incentivebalance);
SC(:,1:show.w-1 )=inf;

end