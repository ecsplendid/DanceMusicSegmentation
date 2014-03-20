function [SC] = getcost_contig(...
    C, W, min_w, ...
    costcontig_incentivebalance) 
%%
T = size(C,1);
SC = inf( T, W );

C_bigdags = getmatrix_indiagonals(C, 1);

%%
tic;
for w=min_w:W
    for t=1:T-w+1
%%
        % we have the triangle
        C_dags = C_bigdags(1:w, t:t+w-1);
 
        % we are looking for adjacent blues and reds
        % on the diags away from center
        
        gwin = gausswin(w);
        
        score = 0;
        
         % for every dag (no point looking at first one though)
        for d=2:size( C_dags, 1 )
            
            C_line = C_dags( d, 1:size( C_dags, 1 )-d+1 );

            for i=2:length( C_line )

                le = C_line(i-1);
                ri = C_line(i);

                score = score +  get_contigcost( ...
                    le, ri, i, ...
                    w, costcontig_incentivebalance, gwin );
               
            end
        end
        
        SC(t, w) = score;
 %%
    end
    
end
toc;

SC = normalize_byincentivebias(SC, costcontig_incentivebalance);

SC(:,1:min_w )=inf;




end