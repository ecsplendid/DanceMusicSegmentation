function [ SC ] = getcost_symmetry( C, W, min_w, ...
    costsymmetry_incentivebalance )
% getcost_symmetry reference implementation takes diagonals of every single
% track square in C and compares symmetric pairs going for the outside
% inwards, normalizing on track width only. runs in O(WTW^2) time

%%
T = size(C,1);

SC = inf( T, W );

C_bigdags = getmatrix_indiagonals(C, 1, W);

for width=min_w:W
    for t=1:T-width+1
        %%
        
        % we have the triangle
        C_dags = C_bigdags(1:width, t:t+width-2);
        
        cost = 0;
       
        % for every dag (no point looking at first one though)
        for d=2:size( C_dags, 1 )
            
            dag_size = size( C_dags, 1 )-(d-1);
            first_half = ceil(dag_size/2);
            
            for i=1:first_half
              
                p1 = C_dags(d-1,i);
                p2 = C_dags(d-1,dag_size-i+1 );
                
                if( p1 < 0 && p2 < 0 )
                    
                    mix = abs(p1+p2)/2;
                    new_cost = (mix) / width;
                    new_cost = new_cost * costsymmetry_incentivebalance;
                    cost = cost -new_cost;

                elseif( p1 > 0 && p2 > 0 )
                    
                    mix = abs(p1+p2)/2;
                    new_cost = (mix) / width;
                    new_cost = new_cost * (1-costsymmetry_incentivebalance);
                    cost = cost +new_cost;

                end
            end   
        end
        
        %%
        SC(t, width) = cost;
    end
end

SC = normalize_byincentivebias(SC, costsymmetry_incentivebalance);

SC(:,1:min_w-1 )=inf;


%%

end