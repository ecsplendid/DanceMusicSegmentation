function [SC] = getcost_symmetrydiff(...
    C, W, min_w, ...
    costcontig_incentivebalance ) 
 %implementation of the symmetry addition concept

%%
T = size( C, 1 );
SC = inf( T, W );

SF = getmatrix_selfsim( C, W, 1 );
SP = getmatrix_selfsim( C, W, 0 );

%% For every T make a triangle with the symmetry calculation for
% future self similarity and past self similarity

% now shift this triangle along to T-w+1
for width = min_w:W
    for t=1:T-width+1

        TF = SF( t:(t+width-1), 1:width );
        TF = tril( (flipud( TF )) );
        
        TP = SP( t:(t+width-1), 1:width );
        TP = tril(TP);
   
        neg_sign = sign(TF)==-1 | sign(TP)==-1;
        pos_sign = ~neg_sign;
        
        maxes = max(TF, TP);
        mins = min(TF, TP);
        
        maxes(neg_sign) = 0;
        mins(pos_sign) = 0;
        
        sym_mat = maxes + mins;
        
        sym_mat( neg_sign ) = sym_mat( neg_sign ) .* (1-costcontig_incentivebalance);
        sym_mat( pos_sign ) = sym_mat( pos_sign ) .* (costcontig_incentivebalance);
        
        
        sym_mat = diff(sym_mat);
        
    
        
        new_score = sum(sum(sym_mat));
        
        new_score = new_score/width;
        
        SC(t, width) = new_score;

    end
end

SC = normalize_byincentivebias(SC, costcontig_incentivebalance);

SC(:,1:min_w-1 )=inf;

end