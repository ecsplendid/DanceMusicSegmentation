function [SC] = getcost_contigdiag1 ( ...
    C, W, min_w, costdags_incentivebalance) 
%getcost_contigdiag1 "Evolving self-similarity" dynamic programming
%implementation of getcost_contigdiag

%%
T = size(C,1);
SC = inf( T, W );

C_dags = getmatrix_indiagonals( C, 1, W );
C_dags = C_dags( 1:W, : )';

for t = 1:T
    
    score = 0;

    for w=1:min(W, t)
        
        vals = C_dags( t-(w-1), 2:w );
        
        blues = sum(vals( vals<=0 )) * (1-costdags_incentivebalance); 
        reds = sum(vals( vals>0 )) * (costdags_incentivebalance); 
        
        new_score = (blues + reds) * w;
        
        score = score +  new_score;
        
        SC( (t-w)+1, w ) = score / w^2;
    end
end

SC = normalize_byincentivebias(SC, costdags_incentivebalance);

SC(:,1:min_w-1 )=inf;

end