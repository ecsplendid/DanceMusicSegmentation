function [ SC ] = getcost_symmetry( C, W, min_w, ...
    costsymmetry_incentivebalance )
%%
T = size(C,1);

SC = inf( T, W );

C_bigdags = getmatrix_indiagonals(C, 1);

for w=min_w:W
    for t=1:T-w+1

        %%
        % we have the triangle
        C_dags = C_bigdags(1:w, t:t+w-1);
        
        score = 0;
       
        % for every dag (no point looking at first one though)
        for d=2:size( C_dags, 1 )
            
            C_line = C_dags( d, 1:size( C_dags, 1 )-d+1 );

            for i=1:length( C_line )
              
                p1 = C_line(i);
                p2 = C_line( length(C_line)-i+1 );
                
                score = score + ...
                    get_symmetricscore( min_w, ...
                    p1, p2, w, costsymmetry_incentivebalance );
            end
        end

        %%
        
        SC(t, w) = score;
    end
end

SC = normalize_byincentivebias(SC, costsymmetry_incentivebalance);

SC(:,1:min_w )=inf;


%%

end