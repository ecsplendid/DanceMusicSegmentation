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
        
        score = score + sum( C_dags( t-(w-1), 2:w ) ) * w;
        
        SC( (t-w)+1, w ) = score / w^2;
    end
end

SC = normalize_byincentivebias(SC, costdags_incentivebalance);

SC(:,1:min_w-1 )=inf;

end