function [SC] = getcost_contigdiag1 ( ...
    show, config) 
%getcost_contigdiag1 "Evolving self-similarity" dynamic programming
%implementation of getcost_contigdiag

%%
T = show.T;
W = show.W;

if config.use_costcontigevolution == 0
   SC = zeros( T, W ); 
   return;
end

SC = inf( T, show.W );

C_dags = getmatrix_indiagonals( show.CosineMatrix, 1, W );
C_dags = C_dags( 1:W, : )';

costdags_incentivebalance = config.costevolution_incentivebalance;

for t = 1:T
    
    score = 0;

    for w=1:min(W, t)
        
        vals = C_dags( t-(w-1), 2:w );
        
        blues = sum(vals( vals<=0 )) * (1-costdags_incentivebalance); 
        reds = sum(vals( vals>0 )) * (costdags_incentivebalance); 
        
        new_score = (blues + reds) * w;
        
        score = score +  new_score;
        
        SC( (t-w)+1, w ) = score / w^config.costevolution_normalization;
    end
end

SC = normalize_byincentivebias(SC, costdags_incentivebalance);

SC(:,1:show.w-1 )=inf;

SC = SC .* config.use_costcontigevolution;

end